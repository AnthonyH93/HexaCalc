//
//  SecondViewController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2020-07-20.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit

class BinaryViewController: CalculatorViewController {

    //MARK: Properties
    // Number of lines formatBinaryString wraps the binary string across — normally 2
    // (32 bits each) at 64 bits, but UIHelper can widen this on narrow windows where 2
    // lines would render illegibly small (see calculateLayout's compact/iPad branch),
    // and narrows it for smaller word sizes (see UIHelper.binaryLabelFit).
    // Updated from buildLayoutConstraints whenever the computed layout's own value
    // changes, so it always matches what was actually laid out.
    var binaryLineCount = 2
    var binaryDefaultLabel: String { formatBinaryString(stringToConvert: "0") }

    @IBOutlet weak var binVStack: UIStackView!
    @IBOutlet weak var binHStack1: UIStackView!
    @IBOutlet weak var binHStack2: UIStackView!
    @IBOutlet weak var binHStack3: UIStackView!
    @IBOutlet weak var binHStack4: UIStackView!
    @IBOutlet weak var binHStack5: UIStackView!

    @IBOutlet weak var ACBtn: RoundButton!
    @IBOutlet weak var DELBtn: RoundButton!
    @IBOutlet weak var DIVBtn: RoundButton!
    @IBOutlet weak var LSBtn: RoundButton!
    @IBOutlet weak var RSBtn: RoundButton!
    @IBOutlet weak var XORBtn: RoundButton!
    @IBOutlet weak var MULTBtn: RoundButton!
    @IBOutlet weak var ONESBtn: RoundButton!
    @IBOutlet weak var TWOSBtn: RoundButton!
    @IBOutlet weak var ORBtn: RoundButton!
    @IBOutlet weak var SUBBtn: RoundButton!
    @IBOutlet weak var Btn1: RoundButton!
    @IBOutlet weak var ANDBtn: RoundButton!
    @IBOutlet weak var PLUSBtn: RoundButton!
    @IBOutlet weak var Btn0: RoundButton!
    @IBOutlet weak var NOTBtn: RoundButton!
    @IBOutlet weak var EQUALSBtn: RoundButton!
    @IBOutlet weak var Btn00: RoundButton!
    @IBOutlet weak var Btn11: RoundButton!

    //MARK: Variables
    // Word size the label was last laid out for (see buildLayoutConstraints)
    private var renderedWordSize = WordSize.defaultSize

    // Operands of the calculation currently being built, in binary, used for history entries
    var historyLeftValue = ""
    var historyRightValue = ""

    // MARK: Abstract overrides

    override var telemetryTab: TelemetryTab { .Binary }
    override var historyFlagReadMask: Int32 { 2 }
    override var historyFlagShift: Int32 { 1 }
    override var historyFlagClearMask: Int32 { 5 }

    override func deleteLastDigit() {
        deletePressed(DELBtn)
    }

    override func pasteFromClipboard() {
        pasteFromClipboardToBinaryCalculator()
    }

    override func copyTextFromLabel() -> String {
        if runningNumber == "" {
            var currentOutput = outputLabel.text ?? binaryDefaultLabel
            currentOutput = currentOutput.components(separatedBy: .whitespacesAndNewlines).joined()
            var end = false
            for char in currentOutput {
                if char == "0" && !end {
                    currentOutput.remove(at: currentOutput.startIndex)
                }
                else {
                    end = true
                }
            }
            return currentOutput.isEmpty ? "0" : currentOutput
        }
        return runningNumber
    }

    override var supportsWordSize: Bool { true }

    override var outputLabelAccessibilityIdentifier: String { "Binary Output Label" }
    override var defaultLabelValue: String { binaryDefaultLabel }

    override func updateThemeColour(_ colour: UIColor) {
        PLUSBtn.backgroundColor = colour
        SUBBtn.backgroundColor = colour
        MULTBtn.backgroundColor = colour
        DIVBtn.backgroundColor = colour
        EQUALSBtn.backgroundColor = colour
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        outputLabel.accessibilityIdentifier = outputLabelAccessibilityIdentifier
        setupCommonViewDidLoad()
    }

    override func buildLayoutConstraints(width: CGFloat, height: CGFloat) -> [NSLayoutConstraint] {
        let safeInsets = view.safeAreaInsets
        let safeHeight = height - safeInsets.top - safeInsets.bottom
        let iPad = UIDevice.current.userInterfaceIdiom == .pad
        // On iPad, match Decimal/Hexadecimal's grid height (computed with the .large
        // label reference) so all three tabs' button grids are the same size — Binary's
        // own .compact label is shorter, which otherwise leaves it more room and makes
        // its grid noticeably larger than the other two tabs.
        //
        // The .large reference and Binary's actual .compact label use different height
        // formulas (the compact one fits two lines to the label's width), so they can
        // diverge — in a short/wide window the real compact label ends up taller than
        // what the reference budgeted for. Forcing the reference's (too-large) grid
        // height in that case over-constrains the layout (fixed-height grid + fixed-height
        // label demand more room than the safe area has), which Auto Layout resolves by
        // breaking a required constraint — visible as overlapping button rows. Clamping
        // to Binary's own natural (unforced) grid height guarantees the forced height
        // never asks for more room than actually fits.
        let referenceLayout = UIHelper.calculateLayout(width: width, height: safeHeight,
                                                       rows: 5, cols: 4, labelType: .large,
                                                       isIPad: iPad)
        let naturalLayout = UIHelper.calculateLayout(width: width, height: safeHeight,
                                                      rows: 5, cols: 4, labelType: .compact,
                                                      isIPad: iPad)
        let targetGridHeight = iPad ? min(referenceLayout.vStackHeight, naturalLayout.vStackHeight) : nil
        let layout = UIHelper.calculateLayout(width: width, height: safeHeight,
                                              rows: 5, cols: 4, labelType: .compact,
                                              targetGridHeight: targetGridHeight,
                                              isIPad: iPad)
        let (topOffset, bottomOffset) = UIHelper.verticalOffsets(safeHeight: safeHeight, layout: layout, isIPad: iPad)
        // Narrower word sizes have fewer digits to show in the same label box
        let labelFit = UIHelper.binaryLabelFit(bitCount: wordSize.bits, layout: layout)
        renderedWordSize = wordSize

        // Resizing (or a word size change) can change how many lines the binary string
        // wraps across (see calculateLayout's compact/iPad branch and binaryLabelFit) —
        // re-wrap whatever's currently shown to match, skipping error messages, which
        // formatBinaryString can't parse.
        if binaryLineCount != labelFit.lineCount {
            binaryLineCount = labelFit.lineCount
            if let current = outputLabel.text, !current.contains("Error") {
                let digitsOnly = current.components(separatedBy: .whitespacesAndNewlines).joined()
                updateOutputLabel(value: formatBinaryString(stringToConvert: digitsOnly))
            }
        }

        var c = [NSLayoutConstraint]()

        c += [
            binVStack.widthAnchor.constraint(equalToConstant: layout.stackWidth),
            binVStack.heightAnchor.constraint(equalToConstant: layout.vStackHeight),
            binVStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -bottomOffset)
        ]

        for hStack in [binHStack1, binHStack2, binHStack3, binHStack4, binHStack5] as [UIStackView] {
            c += [
                hStack.widthAnchor.constraint(equalToConstant: layout.stackWidth),
                hStack.heightAnchor.constraint(equalToConstant: layout.hStackHeight)
            ]
        }

        c += [
            outputLabel.widthAnchor.constraint(equalToConstant: layout.outputLabelWidth),
            outputLabel.heightAnchor.constraint(equalToConstant: layout.labelHeight),
            outputLabel.bottomAnchor.constraint(equalTo: binVStack.topAnchor, constant: -layout.labelToStackGap),
            outputLabel.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: topOffset)
        ]
        outputLabel.font = UIFont(name: "Avenir Next", size: labelFit.fontSize)
        // The storyboard hardcodes numberOfLines to 2 (Binary's old fixed line count) —
        // with more lines now possible on narrow windows, that stale value truncates
        // the extra lines with "…" instead of showing them.
        outputLabel.numberOfLines = labelFit.lineCount

        let singleBtns: [RoundButton] = [DIVBtn, MULTBtn, SUBBtn, PLUSBtn,
                                         EQUALSBtn, DELBtn, XORBtn, ORBtn,
                                         ANDBtn, NOTBtn, ONESBtn, TWOSBtn,
                                         LSBtn, RSBtn, Btn0, Btn1, Btn00, Btn11]
        for btn in singleBtns {
            c += [
                btn.widthAnchor.constraint(equalToConstant: layout.singleButtonWidth),
                btn.heightAnchor.constraint(equalToConstant: layout.hStackHeight)
            ]
            btn.layer.cornerRadius = layout.cornerRadius
            btn.titleLabel?.font = UIFont.systemFont(ofSize: layout.buttonFontSize, weight: .semibold)
        }

        c += [
            ACBtn.widthAnchor.constraint(equalToConstant: layout.doubleButtonWidth),
            ACBtn.heightAnchor.constraint(equalToConstant: layout.hStackHeight)
        ]
        ACBtn.layer.cornerRadius = layout.cornerRadius
        ACBtn.titleLabel?.font = UIFont.systemFont(ofSize: layout.buttonFontSize, weight: .semibold)

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
            let sharedValue = loadSharedValue(stateController?.convValues.binVal ?? "0", radix: 2)
            var newLabelValue = binaryDefaultLabel
            if (sharedValue == 0) {
                runningNumber = ""
                leftValue = ""
                rightValue = ""
                result = ""
                historyLeftValue = ""
                historyRightValue = ""
                currentOperation = .NULL
                operationStack.removeAll()
            }
            else {
                runningNumber = wordSize.binaryString(sharedValue)
                currentOperation = .NULL
                operationStack.removeAll()
                newLabelValue = formatBinaryString(stringToConvert: runningNumber)
            }
            updateOutputLabel(value: newLabelValue)
        }

        // The word size may have been changed on the Hexadecimal tab, which changes how
        // many digits the label has to fit
        if renderedWordSize != wordSize {
            invalidateCalculatorLayout()
        }

        setupCommonViewWillAppear()
    }

    //MARK: Button Actions
    @IBAction func numberPressed(_ sender: RoundButton) {

        if (stateController?.convValues.largerThan64Bits == true) {
            runningNumber = ""
        }

        if runningNumber.count < wordSize.bits {
            let digit = "\(sender.tag)"
            if ((digit == "0" || digit == "100") && (outputLabel.text == binaryDefaultLabel)) {
                //if 0 is pressed and calculator is showing 0 then do nothing
            }
            else if ((runningNumber.count == wordSize.bits - 1) && (digit == "100" || digit == "11")) {
                //if 00 or 11 is pressed and there is only 1 place left to fill then do nothing
            }
            else {
                var stringToAdd = "\(sender.tag)"
                if (sender.tag == 100) {
                    stringToAdd = "00"
                }
                runningNumber += stringToAdd
                var newLabelValue = runningNumber
                newLabelValue = formatBinaryString(stringToConvert: newLabelValue)
                updateOutputLabel(value: newLabelValue)
                quickUpdateStateController()
            }
        }
    }

    @IBAction func ACPressed(_ sender: RoundButton) {
        runningNumber = ""
        leftValue = ""
        rightValue = ""
        result = ""
        historyLeftValue = ""
        historyRightValue = ""
        currentOperation = .NULL
        operationStack.removeAll()
        updateOutputLabel(value: binaryDefaultLabel)

        stateController?.convValues.largerThan64Bits = false
        stateController?.convValues.decimalVal = "0"
        stateController?.convValues.hexVal = "0"
        stateController?.convValues.binVal = "0"
    }

    @IBAction func deletePressed(_ sender: RoundButton) {

        if (stateController?.convValues.largerThan64Bits == true) { return }

        var currentLabel = outputLabel.text
        if (currentLabel != binaryDefaultLabel) {
            if (runningNumber != "") {
                runningNumber.removeLast()
                if (runningNumber == "") {
                    stateController?.convValues.largerThan64Bits = false
                    stateController?.convValues.decimalVal = "0"
                    stateController?.convValues.hexVal = "0"
                    stateController?.convValues.binVal = "0"
                    updateOutputLabel(value: binaryDefaultLabel)
                }
                else {
                    currentLabel = runningNumber
                    currentLabel = formatBinaryString(stringToConvert: currentLabel ?? binaryDefaultLabel)
                    updateOutputLabel(value: currentLabel ?? binaryDefaultLabel)
                    quickUpdateStateController()
                }
            }
        }
    }

    @IBAction func leftShiftPressed(_ sender: RoundButton) {

        if (stateController?.convValues.largerThan64Bits == true) { return }

        if runningNumber != "", let value = signedValue(ofBinary: runningNumber) {
            let binLeftValue = runningNumber
            let shifted = wordSize.truncate(value << 1)
            showUnaryResult(shifted)

            let calculationData = CalculationData(leftValue: binLeftValue, rightValue: "1", operation: .LeftShift, result: runningNumber, isUnaryOperation: false)
            appendToHistory(calculationData)
        }
    }

    @IBAction func rightShiftPressed(_ sender: RoundButton) {

        if (stateController?.convValues.largerThan64Bits == true) { return }

        if runningNumber != "", let value = signedValue(ofBinary: runningNumber) {
            let binLeftValue = runningNumber
            // Logical shift: the vacated top bit is always filled with 0
            let shifted = wordSize.truncate(Int64(bitPattern: wordSize.pattern(value) >> 1))
            showUnaryResult(shifted)

            let calculationData = CalculationData(leftValue: binLeftValue, rightValue: "1", operation: .RightShift, result: runningNumber, isUnaryOperation: false)
            appendToHistory(calculationData)
        }
    }

    @IBAction func onesCompPressed(_ sender: RoundButton) {

        if (stateController?.convValues.largerThan64Bits == true) { return }

        let currLabel = outputLabel.text
        let spacesRemoved = (currLabel?.components(separatedBy: .whitespacesAndNewlines).joined())!

        // The label can be showing an error message (e.g. after dividing by zero)
        guard let value = signedValue(ofBinary: spacesRemoved) else { return }

        // The operand is whatever is on screen — after an equals nothing has been typed,
        // so runningNumber is empty and the displayed value is the one being complimented
        let binLeftValue = runningNumber == "" ? unpaddedBinaryValue(spacesRemoved) : runningNumber

        showUnaryResult(wordSize.truncate(~value))

        let calculationData = CalculationData(leftValue: binLeftValue, rightValue: "", operation: .Not, result: runningNumber, isUnaryOperation: true)
        appendToHistory(calculationData)
    }

    @IBAction func twosCompPressed(_ sender: RoundButton) {

        if (stateController?.convValues.largerThan64Bits == true || outputLabel.text == binaryDefaultLabel) { return }

        let currLabel = outputLabel.text
        let spacesRemoved = (currLabel?.components(separatedBy: .whitespacesAndNewlines).joined())!
        guard let value = signedValue(ofBinary: spacesRemoved) else { return }

        showUnaryResult(wordSize.truncate(0 &- value))
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
        onesCompPressed(sender)
    }

    @IBAction func dividePressed(_ sender: RoundButton) {
        operation(operation: .Divide)
    }

    @IBAction func multiplyPressed(_ sender: RoundButton) {
        operation(operation: .Multiply)
    }

    @IBAction func minusPressed(_ sender: RoundButton) {
        operation(operation: .Subtract)
    }

    @IBAction func addPressed(_ sender: RoundButton) {
        operation(operation: .Add)
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
            if runningNumber != "", let rightOperand = signedValue(ofBinary: runningNumber) {

                // Defer evaluation when the incoming operator has strictly higher precedence
                if !isEquals && precedence(of: operation) > precedence(of: currentOperation) {
                    operationStack.append((leftValue: leftValue, operation: currentOperation))
                    leftValue = String(rightOperand)
                    historyLeftValue = runningNumber
                    runningNumber = ""
                    currentOperation = operation
                    return
                }

                historyRightValue = runningNumber
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

                let firstResultBinary = binaryHistoryValue(fromDecimal: result)
                appendToHistory(CalculationData(leftValue: historyLeftValue, rightValue: historyRightValue,
                                                operation: currentOperation, result: firstResultBinary, isUnaryOperation: false))
                historyLeftValue = firstResultBinary

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
                        let stackedResultBinary = binaryHistoryValue(fromDecimal: result)
                        appendToHistory(CalculationData(leftValue: binaryHistoryValue(fromDecimal: leftValue),
                                                        rightValue: binaryHistoryValue(fromDecimal: rightValue),
                                                        operation: top.operation, result: stackedResultBinary, isUnaryOperation: false))
                        historyLeftValue = stackedResultBinary
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

                let resultBinary = binaryHistoryValue(fromDecimal: result)
                updateOutputLabel(value: formatBinaryString(stringToConvert: resultBinary))

                historyLeftValue = resultBinary
            }
            currentOperation = isEquals ? .NULL : operation
            if isEquals { operationStack.removeAll() }
        }
        else {
            if runningNumber == "" {
                // Continuing from a previous result: keep it as the left operand
                if (leftValue == "") {
                    leftValue = "0"
                    historyLeftValue = "0"
                }
            }
            else if let leftOperand = signedValue(ofBinary: runningNumber) {
                historyLeftValue = runningNumber
                leftValue = String(leftOperand)
            }
            runningNumber = ""
            currentOperation = operation
        }
    }

    override func wordSizeDidChange(from oldSize: WordSize) {
        resizePendingOperands(from: oldSize)
        historyRightValue = ""
        if leftValue != "" {
            historyLeftValue = binaryHistoryValue(fromDecimal: leftValue)
        }

        if runningNumber != "", let typed = oldSize.value(fromPattern: runningNumber, radix: 2) {
            runningNumber = wordSize.binaryString(wordSize.resized(typed, from: oldSize))
        }

        // Error messages have nothing to wrap, but the label still needs re-fitting
        let digits = (outputLabel.text ?? "0").components(separatedBy: .whitespacesAndNewlines).joined()
        if stateController?.convValues.largerThan64Bits != true,
           let shown = oldSize.value(fromPattern: digits, radix: 2) {
            let wrapped = wordSize.resized(shown, from: oldSize)
            updateOutputLabel(value: formatBinaryString(stringToConvert: wordSize.binaryString(wrapped)))
            if wrapped != shown {
                storeSharedValue(wrapped)
            }
        }

        invalidateCalculatorLayout()
    }

    func formatBinaryString(stringToConvert: String) -> String {
        var manipulatedStringToConvert = stringToConvert
        while (manipulatedStringToConvert.count < wordSize.bits) {
            manipulatedStringToConvert = "0" + manipulatedStringToConvert
        }
        // Split into binaryLineCount even chunks (32/16/8 bits each, depending on what
        // UIHelper decided fits) with hard line breaks, rather than leaving the wrap
        // point to the label's word-wrap — on a wide label (iPad) natural wrapping left
        // far more digits on the first line than the rest.
        let groups = manipulatedStringToConvert.separate(every: 4, with: " ").components(separatedBy: " ")
        let groupsPerLine = max(groups.count / binaryLineCount, 1)
        var lines: [String] = []
        for lineStart in stride(from: 0, to: groups.count, by: groupsPerLine) {
            let lineEnd = min(lineStart + groupsPerLine, groups.count)
            lines.append(groups[lineStart..<lineEnd].joined(separator: " "))
        }
        return lines.joined(separator: "\n")
    }

    // The output label is zero padded to the word size, history entries show the value unpadded
    private func unpaddedBinaryValue(_ binaryValue: String) -> String {
        let unpadded = binaryValue.drop(while: { $0 == "0" })
        return unpadded.isEmpty ? "0" : String(unpadded)
    }

    private func binaryHistoryValue(fromDecimal decimalValue: String) -> String {
        guard let intValue = Int64(decimalValue) else { return decimalValue }
        return wordSize.binaryString(intValue)
    }

    // The typed/displayed binary digits, interpreted as a signed value of the current word size
    private func signedValue(ofBinary binary: String) -> Int64? {
        wordSize.value(fromPattern: binary, radix: 2)
    }

    // Shows the result of a unary operation (shift or complement) as the new typed value
    private func showUnaryResult(_ value: Int64) {
        runningNumber = wordSize.binaryString(value)
        updateOutputLabel(value: formatBinaryString(stringToConvert: runningNumber))
        stateController?.convValues.largerThan64Bits = false
        storeSharedValue(value)
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
        guard let value = signedValue(ofBinary: runningNumber) else { return }
        storeSharedValue(value)
    }

    private func pasteFromClipboardToBinaryCalculator() {
        var pastedInput = ""
        let pasteboard = UIPasteboard.general
        pastedInput = pasteboard.string ?? "0"

        let chars = CharacterSet(charactersIn: "01").inverted
        let strippedSpacesBinary = pastedInput.components(separatedBy: .whitespacesAndNewlines).joined()
        let isValidBinary = strippedSpacesBinary.uppercased().rangeOfCharacter(from: chars) == nil
        // Leading zeroes don't count towards the length, so a value copied from a wider
        // word size's zero-padded label still pastes if it fits
        let significantBinary = String(strippedSpacesBinary.drop(while: { $0 == "0" }))
        if (isValidBinary && significantBinary.count <= wordSize.bits) {
            if (significantBinary.isEmpty) {
                runningNumber = ""
                updateOutputLabel(value: binaryDefaultLabel)
                stateController?.convValues.largerThan64Bits = false
                stateController?.convValues.decimalVal = "0"
                stateController?.convValues.hexVal = "0"
                stateController?.convValues.binVal = "0"
            }
            else {
                runningNumber = significantBinary
                let newLabelValue = formatBinaryString(stringToConvert: runningNumber)
                updateOutputLabel(value: newLabelValue)
                quickUpdateStateController()
            }
        }
        else {
            var alertMessage = "Your clipboad did not contain a valid binary string."
            if (isValidBinary) {
                alertMessage = "The binary string in your clipboard must have a length of \(wordSize.bits) characters or less for the \(wordSize.title) word size."
            }
            let alert = UIAlertController(title: "Paste Failed", message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
