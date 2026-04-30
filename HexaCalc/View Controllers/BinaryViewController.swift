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
    let binaryDefaultLabel: String = "0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000"

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
    var leftBinValue = ""
    var rightBinValue = ""

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
            currentOutput = currentOutput.replacingOccurrences(of: " ", with: "")
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

    override func updateThemeColour(_ colour: UIColor) {
        PLUSBtn.backgroundColor = colour
        SUBBtn.backgroundColor = colour
        MULTBtn.backgroundColor = colour
        DIVBtn.backgroundColor = colour
        EQUALSBtn.backgroundColor = colour
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        outputLabel.accessibilityIdentifier = "Binary Output Label"
        updateOutputLabel(value: binaryDefaultLabel)

        if let savedPreferences = DataPersistence.loadPreferences() {
            updateThemeColour(savedPreferences.colour)
            setupCalculatorTextColour(state: savedPreferences.setCalculatorTextColour, colourToSet: savedPreferences.colour)
        }

        setupOutputLabelGestureRecognizers()
        overrideUserInterfaceStyle = .light
        ReviewManager.requestReviewIfAppropriate()
    }

    override func viewDidLayoutSubviews() {
        let screenWidth = view.bounds.width
        let screenHeight = view.bounds.height

        let hStacks = [binHStack1!, binHStack2!, binHStack3!, binHStack4!, binHStack5!]
        let singleButtons = [DIVBtn!, MULTBtn!, SUBBtn!, PLUSBtn!, EQUALSBtn!, DELBtn!, XORBtn!, ORBtn!, ANDBtn!, NOTBtn!,
                             ONESBtn!, TWOSBtn!, LSBtn!, RSBtn!, Btn0!, Btn1!, Btn00!, Btn11!]
        let doubleButtons = [ACBtn!]

        if UIDevice.current.userInterfaceIdiom == .pad {
            let stackConstraints = UIHelper.iPadSetupStackConstraints(hStacks: hStacks, vStack: binVStack, outputLabel: outputLabel, screenWidth: screenWidth, screenHeight: screenHeight)
            currentConstraints.append(contentsOf: stackConstraints)

            let buttonConstraints = UIHelper.iPadSetupButtonConstraints(singleButtons: singleButtons, doubleButtons: doubleButtons, screenWidth: screenWidth, screenHeight: screenHeight, calculator: 2)
            currentConstraints.append(contentsOf: buttonConstraints)

            let labelConstraints = UIHelper.iPadSetupLabelConstraints(label: outputLabel!, screenWidth: screenWidth, screenHeight: screenHeight, calculator: 2)
            currentConstraints.append(contentsOf: labelConstraints)

            NSLayoutConstraint.activate(currentConstraints)
        }
        else {
            let stackConstraints = UIHelper.setupStackConstraints(hStacks: hStacks, vStack: binVStack, outputLabel: outputLabel, screenWidth: screenWidth)
            NSLayoutConstraint.activate(stackConstraints)

            let buttonConstraints = UIHelper.setupButtonConstraints(singleButtons: singleButtons, doubleButtons: doubleButtons, screenWidth: screenWidth, calculator: 2)
            NSLayoutConstraint.activate(buttonConstraints)

            let labelConstraints = UIHelper.setupLabelConstraints(label: outputLabel!, screenWidth: screenWidth, calculator: 2)
            NSLayoutConstraint.activate(labelConstraints)
        }
    }

    // Load the current converted value from either of the other calculator screens
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if ((stateController?.convValues.largerThan64Bits)!) {
            updateOutputLabel(value: "Error! Integer Overflow!")
            telemetryManager.sendCalculatorSignal(tab: telemetryTab, action: TelemetryCalculatorAction.Overflow)
        }
        else {
            var newLabelValue = stateController?.convValues.binVal
            if (newLabelValue == "0") {
                newLabelValue = binaryDefaultLabel
                runningNumber = ""
                leftValue = ""
                rightValue = ""
                result = ""
                currentOperation = .NULL
            }
            else {
                if (newLabelValue!.contains("-")) {
                    newLabelValue = formatNegativeBinaryString(stringToConvert: newLabelValue ?? binaryDefaultLabel)
                }
                runningNumber = newLabelValue ?? ""
                currentOperation = .NULL
                newLabelValue = formatBinaryString(stringToConvert: newLabelValue ?? binaryDefaultLabel)
            }
            updateOutputLabel(value: newLabelValue ?? binaryDefaultLabel)
        }

        setupCommonViewWillAppear()
    }

    //MARK: Button Actions
    @IBAction func numberPressed(_ sender: RoundButton) {

        if (stateController?.convValues.largerThan64Bits == true) {
            runningNumber = ""
        }

        if runningNumber.count <= 63 {
            let digit = "\(sender.tag)"
            if ((digit == "0" || digit == "100") && (outputLabel.text == binaryDefaultLabel)) {
                //if 0 is pressed and calculator is showing 0 then do nothing
            }
            else if ((runningNumber.count == 63) && (digit == "100" || digit == "11")) {
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
        currentOperation = .NULL
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

        var currentValue = ""
        if runningNumber != "" {
            let binLeftValue = runningNumber

            if (runningNumber.first == "1" && runningNumber.count == 64) {
                currentValue = String(Int64(bitPattern: UInt64(runningNumber, radix: 2)!))
            }
            else {
                currentValue = String(Int(runningNumber, radix: 2)!)
            }
            currentValue = "\(Int(currentValue)! << 1)"

            stateController?.convValues.decimalVal = currentValue
            let hexConversion = String(Int64(currentValue)!, radix: 16)
            let binConversion = String(Int64(currentValue)!, radix: 2)
            stateController?.convValues.hexVal = hexConversion
            stateController?.convValues.binVal = binConversion

            var newLabelValue = binConversion
            if (binConversion.contains("-")) {
                newLabelValue = formatNegativeBinaryString(stringToConvert: binConversion)
            }
            runningNumber = newLabelValue
            let labelValueBeforeSpaces = newLabelValue
            newLabelValue = formatBinaryString(stringToConvert: newLabelValue)
            updateOutputLabel(value: newLabelValue)

            let unaryCalculationResult = labelValueBeforeSpaces == "" ? "0" : labelValueBeforeSpaces
            let calculationData = CalculationData(leftValue: binLeftValue, rightValue: "1", operation: .LeftShift, result: unaryCalculationResult, isUnaryOperation: false)
            calculationHistory.insert(calculationData, at: 0)
        }
    }

    @IBAction func rightShiftPressed(_ sender: RoundButton) {

        if (stateController?.convValues.largerThan64Bits == true) { return }

        if runningNumber != "" {
            let binLeftValue = runningNumber

            let currLabel = outputLabel.text
            let spacesRemoved = (currLabel?.components(separatedBy: " ").joined(separator: ""))!
            let rightShifted = String(Int(UInt64(spacesRemoved.dropLast(), radix: 2)!))

            stateController?.convValues.decimalVal = rightShifted
            let hexConversion = String(Int64(rightShifted)!, radix: 16)
            let binConversion = String(Int64(rightShifted)!, radix: 2)
            stateController?.convValues.hexVal = hexConversion
            stateController?.convValues.binVal = binConversion

            var newLabelValue = binConversion
            if (binConversion.contains("-")) {
                newLabelValue = formatNegativeBinaryString(stringToConvert: binConversion)
            }
            runningNumber = newLabelValue
            let labelValueBeforeSpaces = newLabelValue
            newLabelValue = formatBinaryString(stringToConvert: newLabelValue)
            updateOutputLabel(value: newLabelValue)

            let unaryCalculationResult = labelValueBeforeSpaces == "" ? "0" : labelValueBeforeSpaces
            let calculationData = CalculationData(leftValue: binLeftValue, rightValue: "1", operation: .RightShift, result: unaryCalculationResult, isUnaryOperation: false)
            calculationHistory.insert(calculationData, at: 0)
        }
    }

    @IBAction func onesCompPressed(_ sender: RoundButton) {

        if (stateController?.convValues.largerThan64Bits == true) { return }

        let binLeftValue = runningNumber == "" ? "0" : runningNumber

        let currLabel = outputLabel.text
        let spacesRemoved = (currLabel?.components(separatedBy: " ").joined(separator: ""))!
        let castInt = UInt64(spacesRemoved, radix: 2)!
        let onesComplimentInt = ~castInt
        let onesComplimentString = String(onesComplimentInt, radix: 2)

        if (onesComplimentString.first == "1" && onesComplimentString.count == 64) {
            runningNumber = onesComplimentString
        }
        else {
            let asInt = Int(onesComplimentString)
            let removedLeadingZeroes = "\(asInt ?? 0)"
            runningNumber = removedLeadingZeroes
        }
        var newLabelValue = onesComplimentString
        newLabelValue = formatBinaryString(stringToConvert: newLabelValue)
        updateOutputLabel(value: newLabelValue)

        let unaryCalculationResult = onesComplimentString == "" ? "0" : onesComplimentString
        let calculationData = CalculationData(leftValue: binLeftValue, rightValue: "", operation: .Not, result: unaryCalculationResult, isUnaryOperation: true)
        calculationHistory.insert(calculationData, at: 0)

        quickUpdateStateController()
    }

    @IBAction func twosCompPressed(_ sender: RoundButton) {

        if (stateController?.convValues.largerThan64Bits == true || outputLabel.text == binaryDefaultLabel) { return }

        let currLabel = outputLabel.text
        let spacesRemoved = (currLabel?.components(separatedBy: " ").joined(separator: ""))!
        let castInt = UInt64(spacesRemoved, radix: 2)!
        let twosComplimentInt = ~castInt + 1
        let twosComplimentString = String(twosComplimentInt, radix: 2)

        if (twosComplimentString.first == "1" && twosComplimentString.count == 64) {
            runningNumber = twosComplimentString
        }
        else {
            let asInt = Int(twosComplimentString)
            let removedLeadingZeroes = "\(asInt ?? 0)"
            runningNumber = removedLeadingZeroes
        }
        var newLabelValue = twosComplimentString
        newLabelValue = formatBinaryString(stringToConvert: newLabelValue)
        updateOutputLabel(value: newLabelValue)

        quickUpdateStateController()
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
        operation(operation: currentOperation)

        telemetryManager.sendCalculatorSignal(tab: telemetryTab, action: TelemetryCalculatorAction.Equals)
        ReviewManager.incrementReviewWorthyCount()
    }

    //MARK: Private Functions

    private func operation(operation: Operation) {
        if currentOperation != .NULL {
            if runningNumber != "" {

                leftBinValue = runningNumber

                if (runningNumber.first == "1" && runningNumber.count == 64) {
                    rightValue = String(Int64(bitPattern: UInt64(runningNumber, radix: 2)!))
                }
                else {
                    rightValue = String(Int(runningNumber, radix: 2)!)
                }
                runningNumber = ""

                switch (currentOperation) {
                case .Add:
                    let overCheck = Int64(leftValue)!.addingReportingOverflow(Int64(rightValue)!)
                    if (overCheck.overflow) {
                        result = "Error! Integer Overflow!"
                        updateOutputLabel(value: result)
                        currentOperation = operation
                        stateController?.convValues.largerThan64Bits = true
                        stateController?.convValues.decimalVal = "0"
                        return
                    }
                    else {
                        result = "\(Int(leftValue)! + Int(rightValue)!)"
                    }

                case .Subtract:
                    let overCheck = Int64(leftValue)!.subtractingReportingOverflow(Int64(rightValue)!)
                    if (overCheck.overflow) {
                        result = "Error! Integer Overflow!"
                        updateOutputLabel(value: result)
                        currentOperation = operation
                        stateController?.convValues.largerThan64Bits = true
                        stateController?.convValues.decimalVal = "0"
                        return
                    }
                    else {
                        result = "\(Int(leftValue)! - Int(rightValue)!)"
                    }

                case .Multiply:
                    let overCheck = Int64(leftValue)!.multipliedReportingOverflow(by: Int64(rightValue)!)
                    if (overCheck.overflow) {
                        result = "Error! Integer Overflow!"
                        updateOutputLabel(value: result)
                        currentOperation = operation
                        stateController?.convValues.largerThan64Bits = true
                        stateController?.convValues.decimalVal = "0"
                        return
                    }
                    else {
                        result = "\(Int(leftValue)! * Int(rightValue)!)"
                    }

                case .Divide:
                    if Int(rightValue)! == 0 {
                        result = "Error!"
                        updateOutputLabel(value: result)
                        currentOperation = operation
                        return
                    }
                    let overCheck = Int64(leftValue)!.dividedReportingOverflow(by: Int64(rightValue)!)
                    if (overCheck.overflow) {
                        result = "Error! Integer Overflow!"
                        updateOutputLabel(value: result)
                        currentOperation = operation
                        stateController?.convValues.largerThan64Bits = true
                        stateController?.convValues.decimalVal = "0"
                        return
                    }
                    else {
                        result = "\(Int(leftValue)! / Int(rightValue)!)"
                    }

                case .AND:
                    result = "\(Int(leftValue)! & Int(rightValue)!)"

                case .OR:
                    result = "\(Int(leftValue)! | Int(rightValue)!)"

                case .XOR:
                    result = "\(Int(leftValue)! ^ Int(rightValue)!)"

                default:
                    fatalError("Unexpected Operation...")
                }

                leftValue = result
                setupStateControllerValues()

                let binaryRepresentation = stateController?.convValues.binVal ?? binaryDefaultLabel
                var newLabelValue = binaryRepresentation
                if (binaryRepresentation.contains("-")) {
                    newLabelValue = formatNegativeBinaryString(stringToConvert: binaryRepresentation)
                }
                let labelValueBeforeSpaces = newLabelValue
                newLabelValue = formatBinaryString(stringToConvert: newLabelValue)
                updateOutputLabel(value: newLabelValue)

                let calculationData = CalculationData(leftValue: leftBinValue, rightValue: rightBinValue, operation: operation, result: labelValueBeforeSpaces, isUnaryOperation: false)
                calculationHistory.insert(calculationData, at: 0)

                rightBinValue = newLabelValue
            }
            currentOperation = operation
        }
        else {
            rightBinValue = runningNumber
            if runningNumber == "" {
                if (leftValue == "") {
                    leftValue = "0"
                }
            }
            else {
                if (runningNumber.first == "1" && runningNumber.count == 64) {
                    leftValue = String(Int64(bitPattern: UInt64(runningNumber, radix: 2)!))
                }
                else {
                    leftValue = String(Int(runningNumber, radix: 2)!)
                }
            }
            runningNumber = ""
            currentOperation = operation
        }
    }

    func formatBinaryString(stringToConvert: String) -> String {
        var manipulatedStringToConvert = stringToConvert
        while (manipulatedStringToConvert.count < 64) {
            manipulatedStringToConvert = "0" + manipulatedStringToConvert
        }
        return manipulatedStringToConvert.separate(every: 4, with: " ")
    }

    func formatNegativeBinaryString(stringToConvert: String) -> String {
        var manipulatedStringToConvert = stringToConvert
        manipulatedStringToConvert.removeFirst()
        var newString = ""

        for i in 0..<manipulatedStringToConvert.count {
            if (manipulatedStringToConvert[manipulatedStringToConvert.index(manipulatedStringToConvert.startIndex, offsetBy: i)] == "0") {
                newString += "1"
            }
            else {
                newString += "0"
            }
        }

        let index = newString.lastIndex(of: "0") ?? (newString.endIndex)
        var newSubString = String(newString.prefix(upTo: index))

        if (newSubString.count < newString.count) {
            newSubString = newSubString + "1"
        }
        while (newSubString.count < newString.count) {
            newSubString = newSubString + "0"
        }
        while (newSubString.count < 64) {
            newSubString = "1" + newSubString
        }

        return newSubString
    }

    private func setupStateControllerValues() {
        stateController?.convValues.decimalVal = result
        let hexConversion = String(Int(result)!, radix: 16)
        let binConversion = String(Int(result)!, radix: 2)
        stateController?.convValues.hexVal = hexConversion
        stateController?.convValues.binVal = binConversion
    }

    private func quickUpdateStateController() {

        if (runningNumber.count < 65) {
            stateController?.convValues.largerThan64Bits = false
        }

        stateController?.convValues.binVal = runningNumber
        var hexCurrentVal = ""
        var decCurrentVal = ""
        if (outputLabel.text?.first == "1") {
            let currLabel = outputLabel.text
            let spacesRemoved = (currLabel?.components(separatedBy: " ").joined(separator: ""))!
            stateController?.convValues.binVal = spacesRemoved
            decCurrentVal = String(Int64(bitPattern: UInt64(spacesRemoved, radix: 2)!))
            hexCurrentVal = String(Int64(bitPattern: UInt64(spacesRemoved, radix: 2)!), radix: 16)
        }
        else {
            hexCurrentVal = String(Int(runningNumber, radix: 2)!, radix: 16)
            decCurrentVal = String(Int(runningNumber, radix: 2)!)
        }
        stateController?.convValues.hexVal = hexCurrentVal
        stateController?.convValues.decimalVal = decCurrentVal
    }

    private func pasteFromClipboardToBinaryCalculator() {
        var pastedInput = ""
        let pasteboard = UIPasteboard.general
        pastedInput = pasteboard.string ?? "0"

        let chars = CharacterSet(charactersIn: "01").inverted
        let strippedSpacesBinary = pastedInput.components(separatedBy: .whitespacesAndNewlines).joined()
        let isValidBinary = strippedSpacesBinary.uppercased().rangeOfCharacter(from: chars) == nil
        if (isValidBinary && strippedSpacesBinary.count <= 64) {
            if (pastedInput == "0") {
                runningNumber = ""
                updateOutputLabel(value: binaryDefaultLabel)
                stateController?.convValues.largerThan64Bits = false
                stateController?.convValues.decimalVal = "0"
                stateController?.convValues.hexVal = "0"
                stateController?.convValues.binVal = "0"
            }
            else {
                runningNumber = strippedSpacesBinary
                let newLabelValue = formatBinaryString(stringToConvert: runningNumber)
                updateOutputLabel(value: newLabelValue)
                quickUpdateStateController()
            }
        }
        else {
            var alertMessage = "Your clipboad did not contain a valid binary string."
            if (isValidBinary) {
                alertMessage = "The binary string in your clipboard must have a length of 64 characters or less."
            }
            let alert = UIAlertController(title: "Paste Failed", message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
