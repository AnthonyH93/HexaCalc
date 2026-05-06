//
//  CalculatorViewController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2026-04-30.
//  Copyright © 2026 Anthony Hopkins. All rights reserved.
//

import UIKit

// Base class for all calculator tabs. Holds shared state, gesture handling,
// clipboard actions, and lifecycle helpers. Subclasses provide the
// calculator-specific outlet wiring, label updates, and arithmetic logic
// by overriding the abstract computed properties and methods below.
class CalculatorViewController: UIViewController, HistoryButtonHost {

    // MARK: Common outlet – connected in IB for each subclass scene
    @IBOutlet weak var outputLabel: UILabel!

    // MARK: HistoryButtonHost
    var historyButton: UIButton!
    var historyButtonWidthConstraint: NSLayoutConstraint?
    var historyButtonHorizontalConstraint: NSLayoutConstraint?

    // MARK: Shared state
    var stateController: StateController?
    var runningNumber = ""
    var leftValue = ""
    var rightValue = ""
    var result = ""
    var currentOperation: Operation = .NULL
    var currentConstraints: [NSLayoutConstraint] = []
    var currentlyRecognizingDoubleTap = false
    var calculationHistory: [CalculationData] = []
    let telemetryManager = TelemetryManager.sharedTelemetryManager

    // MARK: Abstract – subclasses must override

    var telemetryTab: TelemetryTab {
        fatalError("Subclass must override telemetryTab")
    }

    // Bit mask to read from clearLocalHistory (1 = decimal, 2 = binary, 4 = hex)
    var historyFlagReadMask: Int32 {
        fatalError("Subclass must override historyFlagReadMask")
    }

    // Right-shift to apply after masking (bit 0 → 0, bit 1 → 1, bit 2 → 2)
    var historyFlagShift: Int32 {
        fatalError("Subclass must override historyFlagShift")
    }

    // Mask to AND when clearing this VC's bit from clearLocalHistory
    var historyFlagClearMask: Int32 {
        fatalError("Subclass must override historyFlagClearMask")
    }

    // Called by the swipe-to-delete gesture; forward to the subclass delete action
    func deleteLastDigit() {
        fatalError("Subclass must override deleteLastDigit()")
    }

    // Perform the actual clipboard paste for the specific number system
    func pasteFromClipboard() {
        fatalError("Subclass must override pasteFromClipboard()")
    }

    // Return the text that should be placed on the clipboard when copying
    func copyTextFromLabel() -> String {
        fatalError("Subclass must override copyTextFromLabel()")
    }

    // Apply the current theme colour to all operator buttons (and any other
    // VC-specific tinted views)
    func updateThemeColour(_ colour: UIColor) {
        fatalError("Subclass must override updateThemeColour(_:)")
    }

    var outputLabelAccessibilityIdentifier: String {
        fatalError("Subclass must override outputLabelAccessibilityIdentifier")
    }

    var defaultLabelValue: String {
        fatalError("Subclass must override defaultLabelValue")
    }

    // MARK: Common lifecycle

    func setupCommonViewDidLoad() {
        updateOutputLabel(value: defaultLabelValue)
        if let colour = stateController?.convValues.colour {
            updateThemeColour(colour)
        }
        setupCalculatorTextColour(
            state: stateController?.convValues.setCalculatorTextColour ?? false,
            colourToSet: stateController?.convValues.colour ?? .systemGreen
        )
        setupOutputLabelGestureRecognizers()
        overrideUserInterfaceStyle = .light
        ReviewManager.requestReviewIfAppropriate()
    }


    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.userInterfaceIdiom == .pad {
            NSLayoutConstraint.deactivate(currentConstraints)
            currentConstraints.removeAll()
        }
    }

    // MARK: viewWillAppear helper

    // Call at the end of each subclass viewWillAppear, after updating the label.
    func setupCommonViewWillAppear() {
        setupHistoryButton()
        updateHistoryButton(stateController: stateController)

        if let colour = stateController?.convValues.colour {
            updateThemeColour(colour)
            historyButton.tintColor = colour
        }

        let needsDoubleTap = stateController?.convValues.copyActionIndex == 1
                          || stateController?.convValues.pasteActionIndex == 1
        if (needsDoubleTap && !currentlyRecognizingDoubleTap)
            || (!needsDoubleTap && currentlyRecognizingDoubleTap) {
            outputLabel.gestureRecognizers?.forEach(outputLabel.removeGestureRecognizer)
            setupOutputLabelGestureRecognizers()
        }

        let flag = ((stateController?.convValues.clearLocalHistory ?? 0) & historyFlagReadMask) >> historyFlagShift
        if flag == 1 {
            calculationHistory = []
            stateController?.convValues.clearLocalHistory &= historyFlagClearMask
        }

        setupCalculatorTextColour(
            state: stateController?.convValues.setCalculatorTextColour ?? false,
            colourToSet: stateController?.convValues.colour ?? UIColor.systemGreen
        )
    }

    // MARK: Gesture recognizer setup

    func setupOutputLabelGestureRecognizers() {
        let labelSingleTap = UITapGestureRecognizer(target: self, action: #selector(labelSingleTapped(_:)))
        labelSingleTap.numberOfTapsRequired = 1
        let labelDoubleTap = UITapGestureRecognizer(target: self, action: #selector(labelDoubleTapped(_:)))
        labelDoubleTap.numberOfTapsRequired = 2
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleLabelSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleLabelSwipes(_:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right

        outputLabel.addGestureRecognizer(leftSwipe)
        outputLabel.addGestureRecognizer(rightSwipe)
        outputLabel.isUserInteractionEnabled = true
        outputLabel.addGestureRecognizer(labelSingleTap)
        outputLabel.addGestureRecognizer(labelDoubleTap)

        currentlyRecognizingDoubleTap = false
        if stateController?.convValues.copyActionIndex == 1 || stateController?.convValues.pasteActionIndex == 1 {
            labelSingleTap.require(toFail: labelDoubleTap)
            currentlyRecognizingDoubleTap = true
        }
    }

    // MARK: Gesture handlers

    @objc func labelSingleTapped(_ sender: UITapGestureRecognizer) {
        if stateController?.convValues.copyActionIndex == 0 || stateController?.convValues.pasteActionIndex == 0 {
            if stateController?.convValues.copyActionIndex == 0 && stateController?.convValues.pasteActionIndex == 0 {
                copyAndPasteSelected()
            } else if stateController?.convValues.copyActionIndex == 0 {
                copySelected()
            } else {
                pasteSelected()
            }
        }
    }

    @objc func labelDoubleTapped(_ sender: UILongPressGestureRecognizer) {
        if stateController?.convValues.copyActionIndex == 1 || stateController?.convValues.pasteActionIndex == 1 {
            if stateController?.convValues.copyActionIndex == 1 && stateController?.convValues.pasteActionIndex == 1 {
                copyAndPasteSelected()
            } else if stateController?.convValues.copyActionIndex == 1 {
                copySelected()
            } else {
                pasteSelected()
            }
        }
    }

    @objc func historyButtonTapped() {
        guard let historyVC = storyboard?.instantiateViewController(withIdentifier: "CalculationHistoryViewController") as? CalculationHistoryViewController else { return }
        historyVC.calculationHistory = calculationHistory
        let nav = UINavigationController(rootViewController: historyVC)
        present(nav, animated: true)
    }

    @objc func handleLabelSwipes(_ sender: UISwipeGestureRecognizer) {
        guard sender.view as? UILabel != nil else { return }
        if sender.direction == .left || sender.direction == .right {
            deleteLastDigit()
            telemetryManager.sendCalculatorSignal(tab: telemetryTab, action: TelemetryCalculatorAction.DeleteSwipe)
        }
    }

    // MARK: Clipboard actions

    func copySelected() {
        let currentOutput = copyTextFromLabel()
        UIPasteboard.general.string = currentOutput
        let alert = UIAlertController(
            title: "Copied to Clipboard",
            message: currentOutput + " has been added to your clipboard.",
            preferredStyle: .alert
        )
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: nil)
        }
        telemetryManager.sendCalculatorSignal(tab: telemetryTab, action: TelemetryCalculatorAction.Copy)
    }

    func pasteSelected() {
        let alert = UIAlertController(
            title: "Paste from Clipboard",
            message: "Press confirm to paste the contents of your clipboard into HexaCalc.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in self.pasteFromClipboard() }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        present(alert, animated: true)
        telemetryManager.sendCalculatorSignal(tab: telemetryTab, action: TelemetryCalculatorAction.Paste)
    }

    func copyAndPasteSelected() {
        let alert = UIAlertController(
            title: "Select Clipboard Action",
            message: "Press the action that you would like to perform.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { _ in self.copySelected() }))
        alert.addAction(UIAlertAction(title: "Paste", style: .default, handler: { _ in self.pasteFromClipboard() }))
        present(alert, animated: true)
        telemetryManager.sendCalculatorSignal(tab: telemetryTab, action: TelemetryCalculatorAction.CopyAndPaste)
    }

    // MARK: History

    func appendToHistory(_ entry: CalculationData) {
        guard stateController?.convValues.historyEnabled ?? true else { return }
        calculationHistory.insert(entry, at: 0)
    }

    // MARK: UI helpers

    func setupCalculatorTextColour(state: Bool, colourToSet: UIColor) {
        outputLabel.textColor = state ? colourToSet : UIColor.white
    }

    func updateOutputLabel(value: String) {
        outputLabel.text = value
        outputLabel.accessibilityLabel = value
    }
}

// MARK: StateControllerProtocol

extension CalculatorViewController: StateControllerProtocol {
    func setState(state: StateController) {
        self.stateController = state
    }
}
