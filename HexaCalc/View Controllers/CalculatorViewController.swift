//
//  CalculatorViewController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2026-04-30.
//  Copyright © 2026 Anthony Hopkins. All rights reserved.
//

import UIKit
import StoreKit

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
    var historyButtonTopConstraint: NSLayoutConstraint?

    // MARK: Shared state
    var stateController: StateController?
    var runningNumber = ""
    var leftValue = ""
    var rightValue = ""
    var result = ""
    var currentOperation: Operation = .NULL
    var currentConstraints: [NSLayoutConstraint] = []
    private var lastLayoutSize: CGSize = .zero
    var currentlyRecognizingDoubleTap = false
    var calculationHistory: [CalculationData] = []
    var operationStack: [(leftValue: String, operation: Operation)] = []
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

    // Build and return all programmatic layout constraints for the current bounds.
    // Called from viewDidLayoutSubviews whenever the size changes.
    func buildLayoutConstraints(width: CGFloat, height: CGFloat) -> [NSLayoutConstraint] {
        fatalError("Subclass must override buildLayoutConstraints(width:height:)")
    }

    var outputLabelAccessibilityIdentifier: String {
        fatalError("Subclass must override outputLabelAccessibilityIdentifier")
    }

    var defaultLabelValue: String {
        fatalError("Subclass must override defaultLabelValue")
    }

    // MARK: Operator precedence (shared by all calculator tabs)

    func precedence(of op: Operation) -> Int {
        switch op {
        case .Multiply, .Divide, .Modulus: return 5
        case .Add, .Subtract:              return 4
        case .LeftShift, .RightShift:      return 3
        case .AND:                         return 2
        case .XOR:                         return 1
        case .OR:                          return 0
        case .Exp:                         return 5
        default:                           return -1
        }
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
    }

    func requestReviewAfterCalculation() {
        guard ReviewManager.requestReviewIfAppropriate() else { return }
        if let scene = view.window?.windowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = view.bounds.size
        guard size != lastLayoutSize, size.width > 0, size.height > 0 else { return }
        lastLayoutSize = size
        NSLayoutConstraint.deactivate(currentConstraints)
        currentConstraints.removeAll()
        currentConstraints = buildLayoutConstraints(width: size.width, height: size.height)
        NSLayoutConstraint.activate(currentConstraints)
        repositionHistoryButton(for: size)
        repositionWordSizeButton(for: size)
    }

    // Forces buildLayoutConstraints to run again on the next layout pass even though the
    // view's size hasn't changed (e.g. Binary's label needs re-fitting for a new word size).
    func invalidateCalculatorLayout() {
        lastLayoutSize = .zero
        view.setNeedsLayout()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.repositionHistoryButton(for: size)
            self.repositionWordSizeButton(for: size)
        })
    }

    // MARK: viewWillAppear helper

    // Call at the end of each subclass viewWillAppear, after updating the label.
    func setupCommonViewWillAppear() {
        setupHistoryButton()
        updateHistoryButton(stateController: stateController)
        if supportsWordSize {
            setupWordSizeButton()
            updateWordSizeButton()
        }

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

    // MARK: Word size (Hexadecimal and Binary only)

    // Subclasses that operate on fixed-width integers override this to show the
    // top-left word size button.
    var supportsWordSize: Bool { false }

    var wordSize: WordSize { stateController?.convValues.wordSize ?? WordSize.defaultSize }

    var wordSizeButton: UIButton?
    private var wordSizeButtonTopConstraint: NSLayoutConstraint?

    // Called after the shared word size changes while this tab is on screen. Subclasses
    // wrap their displayed value and pending operands to the new width.
    func wordSizeDidChange(from oldSize: WordSize) {}

    func setupWordSizeButton() {
        guard wordSizeButton == nil else { return }

        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.showsMenuAsPrimaryAction = true
        button.accessibilityIdentifier = "Word Size Button"
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
        wordSizeButton = button
        repositionWordSizeButton()
    }

    func repositionWordSizeButton(for targetSize: CGSize? = nil) {
        guard let button = wordSizeButton, button.superview != nil else { return }
        wordSizeButtonTopConstraint?.isActive = false
        let topConstraint = topRowConstraint(for: button, size: targetSize ?? view.bounds.size)
        topConstraint.isActive = true
        wordSizeButtonTopConstraint = topConstraint
    }

    func updateWordSizeButton() {
        guard let button = wordSizeButton else { return }
        let colour = stateController?.convValues.colour ?? .systemGreen

        var config = UIButton.Configuration.plain()
        config.title = wordSize.title
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.boldSystemFont(ofSize: 17)
            return outgoing
        }
        config.image = UIImage(systemName: "chevron.down",
                               withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .bold))
        config.imagePlacement = .trailing
        config.imagePadding = 6
        config.baseForegroundColor = colour
        config.background.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        config.background.cornerRadius = 22
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        button.configuration = config
        button.accessibilityLabel = "Word size, \(wordSize.title)"

        // Largest first, matching how programmer calculators list them
        let actions = WordSize.allCases.reversed().map { size in
            UIAction(title: size.title, state: size == wordSize ? .on : .off) { [weak self] _ in
                self?.selectWordSize(size)
            }
        }
        button.menu = UIMenu(title: "Word Size", children: actions)
    }

    private func selectWordSize(_ newSize: WordSize) {
        let oldSize = wordSize
        guard newSize != oldSize else { return }
        stateController?.convValues.wordSize = newSize
        DataPersistence.saveWordSize(newSize)
        wordSizeDidChange(from: oldSize)
        updateWordSizeButton()
        telemetryManager.sendCalculatorSignal(tab: telemetryTab, action: TelemetryCalculatorAction.WordSizeChanged)
    }

    // Reads the value shared between tabs (hexVal or binVal) wrapped to the current word
    // size. If wrapping changed it — e.g. 300 typed on the Decimal tab viewed at 8 bits —
    // the wrapped value is written back so every tab agrees on what's being shown.
    func loadSharedValue(_ shared: String, radix: Int) -> Int64 {
        guard let wrapped = wordSize.value(fromShared: shared, radix: radix) else { return 0 }
        if let full = WordSize.bits64.value(fromShared: shared, radix: radix), full != wrapped {
            storeSharedValue(wrapped)
        }
        return wrapped
    }

    // Publishes a value to the other tabs in the signed form they all understand
    func storeSharedValue(_ value: Int64) {
        stateController?.convValues.decimalVal = String(value)
        stateController?.convValues.hexVal = String(value, radix: 16)
        stateController?.convValues.binVal = String(value, radix: 2)
    }

    // Wraps the decimal operands of a calculation in progress to the current word size
    func wrapPendingOperands() {
        let wrap: (String) -> String = { value in
            guard let intValue = Int64(value) else { return value }
            return String(self.wordSize.truncate(intValue))
        }
        leftValue = wrap(leftValue)
        rightValue = wrap(rightValue)
        result = wrap(result)
        operationStack = operationStack.map { (leftValue: wrap($0.leftValue), operation: $0.operation) }
    }

    // Evaluates a binary integer operation for the Hexadecimal and Binary tabs, returning
    // the signed decimal result or an error message.
    //
    // At 64 bits this is the original behaviour: signed overflow is reported as an error.
    // Below 64 bits results wrap (two's complement), like a fixed-width register would.
    // Right shift is logical (zero-filling) on the word's bit pattern at every size.
    func evaluateIntegerOperation(_ operation: Operation, _ left: Int64, _ right: Int64) -> String {
        let overflowError = "Error! Integer Overflow!"
        let size = wordSize
        let wraps = size.bits < 64

        let value: Int64
        switch operation {
        case .Add:
            let r = left.addingReportingOverflow(right)
            if r.overflow && !wraps { return overflowError }
            value = r.partialValue

        case .Subtract:
            let r = left.subtractingReportingOverflow(right)
            if r.overflow && !wraps { return overflowError }
            value = r.partialValue

        case .Multiply:
            let r = left.multipliedReportingOverflow(by: right)
            if r.overflow && !wraps { return overflowError }
            value = r.partialValue

        case .Divide:
            if right == 0 { return "Error!" }
            let r = left.dividedReportingOverflow(by: right)
            if r.overflow && !wraps { return overflowError }
            value = r.partialValue

        case .Modulus:
            if right == 0 { return "Error!" }
            // Int64.min % -1 overflows (the true remainder is 0)
            value = left.remainderReportingOverflow(dividingBy: right).partialValue

        case .LeftShift:
            value = left << right

        case .RightShift:
            if right <= 0 {
                value = left
            } else {
                value = Int64(bitPattern: size.pattern(left) >> UInt64(right))
            }

        case .AND:
            value = left & right

        case .OR:
            value = left | right

        case .XOR:
            value = left ^ right

        default:
            fatalError("Unexpected Operation...")
        }

        return String(size.truncate(value))
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
