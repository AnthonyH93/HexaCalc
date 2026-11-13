//
//  FirstViewController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2020-07-20.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit

class HexadecimalViewController: CalculatorViewController {

    //MARK: Properties
    @IBOutlet weak var hexVStack: UIStackView!
    @IBOutlet weak var hexHStack1: UIStackView!
    @IBOutlet weak var hexHStack2: UIStackView!
    @IBOutlet weak var hexHStack3: UIStackView!
    @IBOutlet weak var hexHStack4: UIStackView!
    @IBOutlet weak var hexHStack5: UIStackView!
    @IBOutlet weak var hexHStack6: UIStackView!

    @IBOutlet weak var ACBtn: RoundButton!
    @IBOutlet weak var DELBtn: RoundButton!
    @IBOutlet weak var SecondFunctionBtn: RoundButton!
    @IBOutlet weak var XORBtn: RoundButton!
    @IBOutlet weak var ORBtn: RoundButton!
    @IBOutlet weak var ANDBtn: RoundButton!
    @IBOutlet weak var NOTBtn: RoundButton!
    @IBOutlet weak var DIVBtn: RoundButton!
    @IBOutlet weak var CBtn: RoundButton!
    @IBOutlet weak var DBtn: RoundButton!
    @IBOutlet weak var EBtn: RoundButton!
    @IBOutlet weak var FBtn: RoundButton!
    @IBOutlet weak var MULTBtn: RoundButton!
    @IBOutlet weak var Btn8: RoundButton!
    @IBOutlet weak var Btn9: RoundButton!
    @IBOutlet weak var ABtn: RoundButton!
    @IBOutlet weak var BBtn: RoundButton!
    @IBOutlet weak var SUBBtn: RoundButton!
    @IBOutlet weak var Btn4: RoundButton!
    @IBOutlet weak var Btn5: RoundButton!
    @IBOutlet weak var Btn6: RoundButton!
    @IBOutlet weak var Btn7: RoundButton!
    @IBOutlet weak var PLUSBtn: RoundButton!
    @IBOutlet weak var Btn0: RoundButton!
    @IBOutlet weak var Btn1: RoundButton!
    @IBOutlet weak var Btn2: RoundButton!
    @IBOutlet weak var Btn3: RoundButton!
    @IBOutlet weak var EQUALSBtn: RoundButton!

    //MARK: Variables
    // Operands of the calculation currently being built, in hexadecimal, used for history entries
    var historyLeftValue = ""
    var historyRightValue = ""

    var secondFunctionMode = false

    // MARK: Abstract overrides

    override var telemetryTab: TelemetryTab { .Hexadecimal }
    override var historyFlagReadMask: Int32 { 4 }
    override var historyFlagShift: Int32 { 2 }
    override var historyFlagClearMask: Int32 { 3 }

    override func deleteLastDigit() {
        deletePressed(DELBtn)
    }

    override func pasteFromClipboard() {
        pasteFromClipboardToHexadecimalCalculator()
    }

    override func copyTextFromLabel() -> String {
        if runningNumber == "" {
            return outputLabel.text ?? "0"
        }
        return runningNumber
    }

    override var supportsWordSize: Bool { true }

    override var outputLabelAccessibilityIdentifier: String { "Hexadecimal Output Label" }
    override var defaultLabelValue: String { "0" }

    override func updateThemeColour(_ colour: UIColor) {
        PLUSBtn.backgroundColor = colour
        SUBBtn.backgroundColor = colour
        MULTBtn.backgroundColor = colour
        DIVBtn.backgroundColor = colour
        EQUALSBtn.backgroundColor = colour
        outputLabel.textColor = colour
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        outputLabel.accessibilityIdentifier = outputLabelAccessibilityIdentifier
        setupCommonViewDidLoad()
        if #available(iOS 17.0, *) {
            traitOverrides.horizontalSizeClass = .compact
        }
    }

    override func buildLayoutConstraints(width: CGFloat, height: CGFloat) -> [NSLayoutConstraint] {
        let safeInsets = view.safeAreaInsets
        let safeHeight = height - safeInsets.top - safeInsets.bottom
        let iPad = UIDevice.current.userInterfaceIdiom == .pad
        // Use the grid height that Binary/Decimal naturally produce so all three tabs
        // share the same total grid area for visual consistency when switching tabs.
        let referenceLayout = UIHelper.calculateLayout(width: width, height: safeHeight,
                                                       rows: 5, cols: 4, labelType: .large,
                                                       isIPad: iPad)
        let layout = UIHelper.calculateLayout(width: width, height: safeHeight,
                                              rows: 6, cols: 5, labelType: .large,
                                              targetGridHeight: referenceLayout.vStackHeight,
                                              isIPad: iPad)
        let (topOffset, bottomOffset) = UIHelper.verticalOffsets(safeHeight: safeHeight, layout: layout, isIPad: iPad)
        var c = [NSLayoutConstraint]()

        c += [
            hexVStack.widthAnchor.constraint(equalToConstant: layout.stackWidth),
            hexVStack.heightAnchor.constraint(equalToConstant: layout.vStackHeight),
            hexVStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -bottomOffset)
        ]

        for hStack in [hexHStack1, hexHStack2, hexHStack3, hexHStack4, hexHStack5, hexHStack6] as [UIStackView] {
            c += [
                hStack.widthAnchor.constraint(equalToConstant: layout.stackWidth),
                hStack.heightAnchor.constraint(equalToConstant: layout.hStackHeight)
            ]
        }

        c += [
            outputLabel.widthAnchor.constraint(equalToConstant: layout.outputLabelWidth),
            outputLabel.heightAnchor.constraint(equalToConstant: layout.labelHeight),
            outputLabel.bottomAnchor.constraint(equalTo: hexVStack.topAnchor, constant: -layout.labelToStackGap),
            outputLabel.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: topOffset)
        ]
        outputLabel.font = UIFont(name: "Avenir Next", size: layout.labelFontSize)

        let singleBtns: [RoundButton] = [XORBtn, ORBtn, ANDBtn, NOTBtn, DIVBtn,
                                         MULTBtn, Btn8, Btn9, ABtn, BBtn,
                                         SUBBtn, Btn4, Btn5, Btn6, Btn7,
                                         PLUSBtn, Btn0, Btn1, Btn2, Btn3,
                                         EQUALSBtn, CBtn, DBtn, EBtn, FBtn, SecondFunctionBtn]
        for btn in singleBtns {
            c += [
                btn.widthAnchor.constraint(equalToConstant: layout.singleButtonWidth),
                btn.heightAnchor.constraint(equalToConstant: layout.hStackHeight)
            ]
            btn.layer.cornerRadius = layout.cornerRadius
            btn.titleLabel?.font = UIFont.systemFont(ofSize: layout.buttonFontSize, weight: .semibold)
        }

        for btn in [ACBtn, DELBtn] as [RoundButton] {
            c += [
                btn.widthAnchor.constraint(equalToConstant: layout.doubleButtonWidth),
                btn.heightAnchor.constraint(equalToConstant: layout.hStackHeight)
            ]
            btn.layer.cornerRadius = layout.cornerRadius
            btn.titleLabel?.font = UIFont.systemFont(ofSize: layout.buttonFontSize, weight: .semibold)
        }

        return c
    }

    // Load the current converted value from either of the other calculator screens
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if ((stateController?.convValues.largerThan64Bits)!) {
            updateOutputLabel(value: "Error! Integer Overflow!")
            telemetryManager.sendCalculatorSignal(tab: telemetryTab, action: TelemetryCalculatorAction.Overflow)
        }
        else {
            // The shared value may have been entered on another tab (or before the word
            // size was reduced), so wrap it to the current word size before showing it
            let sharedValue = loadSharedValue(stateController?.convValues.hexVal ?? "0", radix: 16)

            if (sharedValue == 0) {
                updateOutputLabel(value: "0")
                runningNumber = ""
                leftValue = ""
                rightValue = ""
                historyLeftValue = ""
                historyRightValue = ""
                currentOperation = .NULL
                operationStack.removeAll()
            }
            else {
                let newLabelValue = wordSize.hexString(sharedValue)
                runningNumber = newLabelValue
                currentOperation = .NULL
                operationStack.removeAll()
                updateOutputLabel(value: newLabelValue)
            }
        }

        setupCommonViewWillAppear()
    }

    //MARK: Button Actions
    @IBAction func ACPressed(_ sender: RoundButton) {
        runningNumber = ""
        leftValue = ""
        rightValue = ""
        result = ""
        historyLeftValue = ""
        historyRightValue = ""
        currentOperation = .NULL
        operationStack.removeAll()
        updateOutputLabel(value: "0")

        stateController?.convValues.largerThan64Bits = false
        stateController?.convValues.decimalVal = "0"
        stateController?.convValues.hexVal = "0"
        stateController?.convValues.binVal = "0"
    }

    @IBAction func deletePressed(_ sender: RoundButton) {
        if (stateController?.convValues.largerThan64Bits == true) { return }

        if (runningNumber != "0") {
            if (runningNumber != "") {
                runningNumber.removeLast()
                if (runningNumber == "") {
                    stateController?.convValues.largerThan64Bits = false
                    stateController?.convValues.decimalVal = "0"
                    stateController?.convValues.hexVal = "0"
                    stateController?.convValues.binVal = "0"
                    updateOutputLabel(value: "0")
                }
                else {
                    updateOutputLabel(value: runningNumber)
                    quickUpdateStateController()
                }
            }
        }
    }

    @IBAction func secondFunctionPressed(_ sender: RoundButton) {
        let operatorButtons = [DIVBtn, MULTBtn, SUBBtn, PLUSBtn]

        if (self.secondFunctionMode) {
            self.changeOperators(buttons: operatorButtons, secondFunctionActive: false)
            SecondFunctionBtn.backgroundColor = .lightGray
        }
        else {
            self.changeOperators(buttons: operatorButtons, secondFunctionActive: true)
            SecondFunctionBtn.backgroundColor = .white
        }

        self.secondFunctionMode.toggle()

        telemetryManager.sendCalculatorSignal(tab: telemetryTab, action: TelemetryCalculatorAction.Second)
    }

    @IBAction func digitPressed(_ sender: RoundButton) {

        if (stateController?.convValues.largerThan64Bits == true) {
            runningNumber = ""
        }

        if (runningNumber.count < wordSize.hexDigits) {
            let digit = "\(sender.tag)"
            if ((digit == "0") && (outputLabel.text == "0")) {
                //if 0 is pressed and calculator is showing 0 then do nothing
            }
            else {
                let convertedDigit = tagToHex(digitToConvert: digit)
                if (runningNumber == "0") {
                    runningNumber = convertedDigit
                }
                else {
                    runningNumber += convertedDigit
                }
                updateOutputLabel(value: runningNumber)
                quickUpdateStateController()
            }
        }
    }

    @IBAction func XORPressed(_ sender: RoundButton) {
        operation(operation: .XOR)
    }

    @IBAction func ORPressed(_ sender: RoundButton) {
        operation(operation: .OR)
    }

    @IBAction func ANDPressed(_ sender: RoundButton) {
        operation(operation: .AND)
    }

    @IBAction func NOTPressed(_ sender: RoundButton) {

        if (stateController?.convValues.largerThan64Bits == true) { return }

        var currentValue = runningNumber
        if (runningNumber == "") {
            currentValue = outputLabel.text ?? "0"
        }

        // The label can be showing an error message (e.g. after dividing by zero)
        guard let value = signedValue(ofHex: currentValue) else { return }
        let onesComplimentValue = wordSize.truncate(~value)

        runningNumber = wordSize.hexString(onesComplimentValue)
        updateOutputLabel(value: runningNumber)

        let unaryCalculationResult = runningNumber == "" ? "0" : runningNumber
        let calculationData = CalculationData(leftValue: currentValue, rightValue: "", operation: .Not, result: unaryCalculationResult, isUnaryOperation: true)
        appendToHistory(calculationData)

        quickUpdateStateController()
    }

    @IBAction func dividePressed(_ sender: RoundButton) {
        if secondFunctionMode {
            // 2's complement pressed
            if (stateController?.convValues.largerThan64Bits == true || runningNumber == "") { return }

            guard let value = signedValue(ofHex: runningNumber) else { return }
            let twosComplimentValue = wordSize.truncate(0 &- value)

            runningNumber = wordSize.hexString(twosComplimentValue)
            updateOutputLabel(value: runningNumber)
            quickUpdateStateController()
        }
        else {
            operation(operation: .Divide)
        }
    }

    @IBAction func multiplyPressed(_ sender: RoundButton) {
        if secondFunctionMode {
            operation(operation: .Modulus)
        }
        else {
            operation(operation: .Multiply)
        }
    }

    @IBAction func minusPressed(_ sender: RoundButton) {
        if secondFunctionMode {
            operation(operation: .LeftShift)
        }
        else {
            operation(operation: .Subtract)
        }
    }

    @IBAction func plusPressed(_ sender: RoundButton) {
        if secondFunctionMode {
            operation(operation: .RightShift)
        }
        else {
            operation(operation: .Add)
        }
    }

    @IBAction func equalsPressed(_ sender: RoundButton) {
        operation(operation: currentOperation, isEquals: true)

        telemetryManager.sendCalculatorSignal(tab: telemetryTab, action: TelemetryCalculatorAction.Equals)
        ReviewManager.incrementReviewWorthyCount()
        ReviewManager.completedCalculation()
        requestReviewAfterCalculation()
    }

    //MARK: Private Functions

    private func operation(operation: Operation, isEquals: Bool = false) {

        if currentOperation != .NULL {

            if runningNumber != "" {
                historyRightValue = runningNumber
            }

            if let rightOperand = signedValue(ofHex: runningNumber) {

                // Defer evaluation when the incoming operator has strictly higher precedence
                if !isEquals && precedence(of: operation) > precedence(of: currentOperation) {
                    operationStack.append((leftValue: leftValue, operation: currentOperation))
                    leftValue = String(rightOperand)
                    historyLeftValue = runningNumber
                    runningNumber = ""
                    currentOperation = operation
                    return
                }

                rightValue = String(rightOperand)
                runningNumber = ""

                result = evaluateIntegerOperation(currentOperation, Int64(leftValue)!, rightOperand)

                if result.contains("Error") {
                    operationStack.removeAll()
                    updateOutputLabel(value: result)
                    currentOperation = isEquals ? .NULL : operation
                    if result.contains("Overflow") {
                        stateController?.convValues.largerThan64Bits = true
                        stateController?.convValues.decimalVal = "0"
                    }
                    return
                }

                leftValue = result

                let firstResultHex = hexHistoryValue(fromDecimal: result)
                appendToHistory(CalculationData(leftValue: historyLeftValue, rightValue: historyRightValue,
                                                operation: currentOperation, result: firstResultHex, isUnaryOperation: false))
                historyLeftValue = firstResultHex

                // Drain lower-or-equal-precedence stacked operations
                let shouldDrain: (Operation) -> Bool = isEquals
                    ? { _ in true }
                    : { topOp in self.precedence(of: operation) <= self.precedence(of: topOp) }

                while !operationStack.isEmpty && !result.contains("Error") {
                    let top = operationStack.last!
                    guard shouldDrain(top.operation) else { break }
                    operationStack.removeLast()
                    rightValue = result
                    leftValue = top.leftValue

                    result = evaluateIntegerOperation(top.operation, Int64(leftValue)!, Int64(rightValue)!)

                    if !result.contains("Error") {
                        let stackedResultHex = hexHistoryValue(fromDecimal: result)
                        appendToHistory(CalculationData(leftValue: hexHistoryValue(fromDecimal: leftValue),
                                                        rightValue: hexHistoryValue(fromDecimal: rightValue),
                                                        operation: top.operation, result: stackedResultHex, isUnaryOperation: false))
                        historyLeftValue = stackedResultHex
                        leftValue = result
                    }
                }

                if result.contains("Error") {
                    operationStack.removeAll()
                    updateOutputLabel(value: result)
                    currentOperation = isEquals ? .NULL : operation
                    if result.contains("Overflow") {
                        stateController?.convValues.largerThan64Bits = true
                        stateController?.convValues.decimalVal = "0"
                    }
                    return
                }

                leftValue = result
                setupStateControllerValues()

                let newLabelValue = hexHistoryValue(fromDecimal: result)
                updateOutputLabel(value: newLabelValue)

                historyLeftValue = newLabelValue
            }
            currentOperation = isEquals ? .NULL : operation
            if isEquals { operationStack.removeAll() }
        }
        else {
            if (runningNumber == "") {
                // Continuing from a previous result: keep it as the left operand
                if (leftValue == "") {
                    leftValue = "0"
                    historyLeftValue = "0"
                }
            }
            else if let leftOperand = signedValue(ofHex: runningNumber) {
                historyLeftValue = runningNumber
                leftValue = String(leftOperand)
            }
            runningNumber = ""
            currentOperation = operation
        }
    }

    override func wordSizeDidChange(from oldSize: WordSize) {
        wrapPendingOperands()
        historyRightValue = ""
        if leftValue != "" {
            historyLeftValue = hexHistoryValue(fromDecimal: leftValue)
        }

        if runningNumber != "", let typed = oldSize.value(fromPattern: runningNumber, radix: 16) {
            runningNumber = wordSize.hexString(wordSize.truncate(typed))
        }

        // Error messages have nothing to wrap
        guard stateController?.convValues.largerThan64Bits != true,
              let shown = oldSize.value(fromPattern: outputLabel.text ?? "0", radix: 16) else { return }
        let wrapped = wordSize.truncate(shown)
        updateOutputLabel(value: wordSize.hexString(wrapped))
        if wrapped != shown {
            storeSharedValue(wrapped)
        }
    }

    private func setupStateControllerValues() {
        stateController?.convValues.decimalVal = result
        let hexConversion = String(Int(result)!, radix: 16)
        let binConversion = String(Int(result)!, radix: 2)
        stateController?.convValues.hexVal = hexConversion
        stateController?.convValues.binVal = binConversion
    }

    private func quickUpdateStateController() {
        stateController?.convValues.largerThan64Bits = false
        guard let value = signedValue(ofHex: runningNumber) else { return }
        storeSharedValue(value)
    }

    // The typed/displayed hex digits, interpreted as a signed value of the current word size
    private func signedValue(ofHex hex: String) -> Int64? {
        wordSize.value(fromPattern: hex, radix: 16)
    }

    private func tagToHex(digitToConvert: String) -> String {
        var result = ""
        if (Int(digitToConvert)! < 10) {
            result = digitToConvert
        }
        else {
            switch Int(digitToConvert)! {
            case 10: result = "A"
            case 11: result = "B"
            case 12: result = "C"
            case 13: result = "D"
            case 14: result = "E"
            case 15: result = "F"
            default: break
            }
        }
        return result
    }

    private func hexHistoryValue(fromDecimal decimalValue: String) -> String {
        guard let intValue = Int64(decimalValue) else { return decimalValue }
        return wordSize.hexString(intValue)
    }

    private func changeOperators(buttons: [RoundButton?], secondFunctionActive: Bool) {
        if secondFunctionActive {
            for (i, button) in buttons.enumerated() {
                switch i {
                case 0: button?.setTitle("2's", for: .normal)
                case 1: button?.setTitle("MOD", for: .normal)
                case 2: button?.setTitle("<<X", for: .normal)
                case 3: button?.setTitle(">>X", for: .normal)
                default: fatalError("Index out of range")
                }
            }
        }
        else {
            for (i, button) in buttons.enumerated() {
                switch i {
                case 0: button?.setTitle("÷", for: .normal)
                case 1: button?.setTitle("×", for: .normal)
                case 2: button?.setTitle("-", for: .normal)
                case 3: button?.setTitle("+", for: .normal)
                default: fatalError("Index out of range")
                }
            }
        }
    }

    private func pasteFromClipboardToHexadecimalCalculator() {
        var pastedInput = ""
        let pasteboard = UIPasteboard.general
        pastedInput = pasteboard.string ?? "0"

        let chars = CharacterSet(charactersIn: "0123456789ABCDEF").inverted
        var strippedSpacesHexadecimal = pastedInput.components(separatedBy: .whitespacesAndNewlines).joined()
        let isValidHexadecimal = strippedSpacesHexadecimal.uppercased().rangeOfCharacter(from: chars) == nil
        if (strippedSpacesHexadecimal.hasPrefix("0")) {
            strippedSpacesHexadecimal = strippedSpacesHexadecimal.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
        }
        if (isValidHexadecimal && strippedSpacesHexadecimal.count <= wordSize.hexDigits) {
            // Only zeroes were pasted (leading zeroes are stripped above)
            if (strippedSpacesHexadecimal.isEmpty) {
                runningNumber = ""
                leftValue = ""
                rightValue = ""
                result = ""
                historyLeftValue = ""
                historyRightValue = ""
                updateOutputLabel(value: "0")
                stateController?.convValues.largerThan64Bits = false
                stateController?.convValues.decimalVal = "0"
                stateController?.convValues.hexVal = "0"
                stateController?.convValues.binVal = "0"
            }
            else {
                runningNumber = strippedSpacesHexadecimal.uppercased()
                updateOutputLabel(value: runningNumber)
                quickUpdateStateController()
            }
        }
        else {
            var alertMessage = "Your clipboad did not contain a valid hexadecimal string."
            if (isValidHexadecimal) {
                alertMessage = "The hexadecimal string in your clipboard must have a length of \(wordSize.hexDigits) characters or less for the \(wordSize.title) word size."
            }
            let alert = UIAlertController(title: "Paste Failed", message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
