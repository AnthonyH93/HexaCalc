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
    var leftValueHex = ""
    var leftHexValue = ""
    var rightHexValue = ""

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

        outputLabel.accessibilityIdentifier = "Hexadecimal Output Label"
        updateOutputLabel(value: "0")

        // convValues is pre-populated by HexaCalcTabBarController.viewDidLoad before any child VC loads
        if let colour = stateController?.convValues.colour {
            updateThemeColour(colour)
        }
        setupCalculatorTextColour(
            state: stateController?.convValues.setCalculatorTextColour ?? false,
            colourToSet: stateController?.convValues.colour ?? .systemGreen
        )

        setupOutputLabelGestureRecognizers()
        overrideUserInterfaceStyle = .light

        if #available(iOS 17.0, *) {
            traitOverrides.horizontalSizeClass = .compact
        }

        ReviewManager.requestReviewIfAppropriate()
    }

    override func viewDidLayoutSubviews() {
        let screenWidth = view.bounds.width
        let screenHeight = view.bounds.height

        let hStacks = [hexHStack1!, hexHStack2!, hexHStack3!, hexHStack4!, hexHStack5!, hexHStack6!]
        let singleButtons = [XORBtn!, ORBtn!, ANDBtn!, NOTBtn!, DIVBtn!, MULTBtn!, SUBBtn!, PLUSBtn!, EQUALSBtn!,
                             Btn0!, Btn1!, Btn2!, Btn3!, Btn4!, Btn5!, Btn6!, Btn7!, Btn8!, Btn9!,
                             ABtn!, BBtn!, CBtn!, DBtn!, EBtn!, FBtn!, SecondFunctionBtn!]
        let doubleButtons = [ACBtn!, DELBtn!]

        if UIDevice.current.userInterfaceIdiom == .pad {
            let stackConstraints = UIHelper.iPadSetupStackConstraints(hStacks: hStacks, vStack: hexVStack, outputLabel: outputLabel, screenWidth: screenWidth, screenHeight: screenHeight)
            currentConstraints.append(contentsOf: stackConstraints)

            let buttonConstraints = UIHelper.iPadSetupButtonConstraints(singleButtons: singleButtons, doubleButtons: doubleButtons, screenWidth: screenWidth, screenHeight: screenHeight, calculator: 1)
            currentConstraints.append(contentsOf: buttonConstraints)

            let labelConstraints = UIHelper.iPadSetupLabelConstraints(label: outputLabel!, screenWidth: screenWidth, screenHeight: screenHeight, calculator: 1)
            currentConstraints.append(contentsOf: labelConstraints)

            NSLayoutConstraint.activate(currentConstraints)
        }
        else {
            let stackConstraints = UIHelper.setupStackConstraints(hStacks: hStacks, vStack: hexVStack, outputLabel: outputLabel, screenWidth: screenWidth)
            NSLayoutConstraint.activate(stackConstraints)

            let buttonConstraints = UIHelper.setupButtonConstraints(singleButtons: singleButtons, doubleButtons: doubleButtons, screenWidth: screenWidth, calculator: 1)
            NSLayoutConstraint.activate(buttonConstraints)

            let labelConstraints = UIHelper.setupLabelConstraints(label: outputLabel!, screenWidth: screenWidth, calculator: 1)
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
            var newLabelValue = stateController?.convValues.hexVal.uppercased()

            if (newLabelValue == "0") {
                updateOutputLabel(value: "0")
                runningNumber = ""
                leftValue = ""
                leftValueHex = ""
                rightValue = ""
                currentOperation = .NULL
            }
            else {
                if (newLabelValue!.contains("-")) {
                    newLabelValue = formatNegativeHex(hexToConvert: newLabelValue ?? "0").uppercased()
                }
                runningNumber = newLabelValue ?? "0"
                currentOperation = .NULL
                updateOutputLabel(value: newLabelValue ?? "0")
            }
        }

        setupCommonViewWillAppear()
    }

    //MARK: Button Actions
    @IBAction func ACPressed(_ sender: RoundButton) {
        runningNumber = ""
        leftValue = ""
        leftValueHex = ""
        rightValue = ""
        result = ""
        currentOperation = .NULL
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

        if (runningNumber.count <= 15) {
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

        let castInt = UInt64(currentValue, radix: 16)!
        let onesComplimentInt = ~castInt

        runningNumber = String(onesComplimentInt, radix: 16).uppercased()
        updateOutputLabel(value: runningNumber)

        let unaryCalculationResult = runningNumber == "" ? "0" : runningNumber
        let calculationData = CalculationData(leftValue: currentValue, rightValue: "", operation: .Not, result: unaryCalculationResult, isUnaryOperation: true)
        calculationHistory.insert(calculationData, at: 0)

        quickUpdateStateController()
    }

    @IBAction func dividePressed(_ sender: RoundButton) {
        if secondFunctionMode {
            // 2's complement pressed
            if (stateController?.convValues.largerThan64Bits == true || runningNumber == "") { return }

            let castInt = UInt64(runningNumber, radix: 16)!
            let twosComplimentInt = ~castInt + 1

            runningNumber = String(twosComplimentInt, radix: 16).uppercased()
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
        operation(operation: currentOperation)

        telemetryManager.sendCalculatorSignal(tab: telemetryTab, action: TelemetryCalculatorAction.Equals)
        ReviewManager.incrementReviewWorthyCount()
    }

    //MARK: Private Functions

    private func operation(operation: Operation) {

        if currentOperation != .NULL {

            if runningNumber != "" {
                leftHexValue = runningNumber
            }

            let binRightValue = hexToBin(hexToConvert: runningNumber)
            if binRightValue != "" {
                if (binRightValue.first == "1" && binRightValue.count == 64) {
                    rightValue = String(Int64(bitPattern: UInt64(binRightValue, radix: 2)!))
                }
                else {
                    rightValue = String(Int(binRightValue, radix: 2)!)
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

                case .Modulus:
                    if Int(rightValue)! == 0 {
                        result = "Error!"
                        updateOutputLabel(value: result)
                        currentOperation = operation
                        return
                    }
                    result = "\(Int(Double(leftValue)!.truncatingRemainder(dividingBy: Double(rightValue)!)))"

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

                case .LeftShift:
                    result = "\(Int(leftValue)! << Int(rightValue)!)"

                case .RightShift:
                    let currValue = hexToBin(hexToConvert: leftValueHex)
                    let rightShiftRight = Int(rightValue)!
                    if (rightShiftRight <= 0) {
                        result = leftValue
                    }
                    else if (rightShiftRight > currValue.count) {
                        result = "0"
                    }
                    else {
                        result = String(Int(UInt64(currValue.dropLast(rightShiftRight), radix: 2)!))
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

                let hexRepresentation = stateController?.convValues.hexVal ?? "0"
                var newLabelValue = hexRepresentation.uppercased()
                leftValueHex = newLabelValue
                if (hexRepresentation.contains("-")) {
                    newLabelValue = formatNegativeHex(hexToConvert: newLabelValue).uppercased()
                }
                updateOutputLabel(value: newLabelValue)

                let calculationData = CalculationData(leftValue: rightHexValue, rightValue: leftHexValue, operation: currentOperation, result: newLabelValue, isUnaryOperation: false)
                calculationHistory.insert(calculationData, at: 0)

                rightHexValue = newLabelValue
            }
            currentOperation = operation
        }
        else {
            rightHexValue = runningNumber
            let binLeftValue = hexToBin(hexToConvert: runningNumber)
            if (runningNumber == "") {
                if (leftValue == "") {
                    leftValue = "0"
                    leftValueHex = "0"
                }
            }
            else {
                leftValueHex = runningNumber
                if (binLeftValue.first == "1" && binLeftValue.count == 64) {
                    leftValue = String(Int64(bitPattern: UInt64(binLeftValue, radix: 2)!))
                }
                else {
                    leftValue = String(Int(binLeftValue, radix: 2)!)
                }
            }
            runningNumber = ""
            currentOperation = operation
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

        if (runningNumber.count < 17) {
            stateController?.convValues.largerThan64Bits = false
        }

        stateController?.convValues.hexVal = runningNumber
        var binCurrentVal = ""
        var decCurrentVal = ""
        if ((!outputLabel.text!.first!.isNumber || ((outputLabel.text!.first == "9") || (outputLabel.text!.first == "8"))) && (outputLabel.text!.count == 16)) {
            var currentLabel = runningNumber
            currentLabel = hexToBin(hexToConvert: currentLabel)
            binCurrentVal = currentLabel
            decCurrentVal = String(Int64(bitPattern: UInt64(currentLabel, radix: 2)!))
        }
        else {
            binCurrentVal = String(Int(runningNumber, radix: 16)!, radix: 2)
            decCurrentVal = String(Int(runningNumber, radix: 16)!)
        }
        stateController?.convValues.binVal = binCurrentVal
        stateController?.convValues.decimalVal = decCurrentVal
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

    private func hexToBin(hexToConvert: String) -> String {
        var result = ""
        var copy = hexToConvert.uppercased()

        if (hexToConvert == "") { return hexToConvert }

        for _ in 0..<hexToConvert.count {
            let currentDigit = copy.first
            copy.removeFirst()

            switch currentDigit {
            case "0": result += "0000"
            case "1": result += "0001"
            case "2": result += "0010"
            case "3": result += "0011"
            case "4": result += "0100"
            case "5": result += "0101"
            case "6": result += "0110"
            case "7": result += "0111"
            case "8": result += "1000"
            case "9": result += "1001"
            case "A": result += "1010"
            case "B": result += "1011"
            case "C": result += "1100"
            case "D": result += "1101"
            case "E": result += "1110"
            case "F": result += "1111"
            default: fatalError("Unexpected Operation...")
            }
        }

        return result
    }

    private func formatNegativeHex(hexToConvert: String) -> String {
        var manipulatedString = hexToConvert
        manipulatedString.removeFirst()

        if (manipulatedString == "8000000000000000") {
            return manipulatedString
        }

        let binaryInitial = String(Int(manipulatedString, radix: 16)!, radix: 2)
        var invertedBinary = ""

        for i in 0..<binaryInitial.count {
            if (binaryInitial[binaryInitial.index(binaryInitial.startIndex, offsetBy: i)] == "0") {
                invertedBinary += "1"
            }
            else {
                invertedBinary += "0"
            }
        }

        let index = invertedBinary.lastIndex(of: "0") ?? (invertedBinary.endIndex)
        var newSubString = String(invertedBinary.prefix(upTo: index))

        if (newSubString.count < invertedBinary.count) {
            newSubString = newSubString + "1"
        }
        while (newSubString.count < invertedBinary.count) {
            newSubString = newSubString + "0"
        }
        while (newSubString.count < 64) {
            newSubString = "1" + newSubString
        }

        var hexResult = ""
        for _ in 0..<16 {
            let currentIndex = newSubString.index(newSubString.endIndex, offsetBy: -4)
            let currentBinary = String(newSubString.suffix(from: currentIndex))
            newSubString.removeLast(4)

            switch currentBinary {
            case "0000": hexResult = "0" + hexResult
            case "0001": hexResult = "1" + hexResult
            case "0010": hexResult = "2" + hexResult
            case "0011": hexResult = "3" + hexResult
            case "0100": hexResult = "4" + hexResult
            case "0101": hexResult = "5" + hexResult
            case "0110": hexResult = "6" + hexResult
            case "0111": hexResult = "7" + hexResult
            case "1000": hexResult = "8" + hexResult
            case "1001": hexResult = "9" + hexResult
            case "1010": hexResult = "a" + hexResult
            case "1011": hexResult = "b" + hexResult
            case "1100": hexResult = "c" + hexResult
            case "1101": hexResult = "d" + hexResult
            case "1110": hexResult = "e" + hexResult
            case "1111": hexResult = "f" + hexResult
            default: fatalError("Unexpected Operation...")
            }
        }

        return hexResult
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
        if (isValidHexadecimal && strippedSpacesHexadecimal.count <= 16) {
            if (pastedInput == "0") {
                runningNumber = ""
                leftValue = ""
                leftValueHex = ""
                rightValue = ""
                result = ""
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
                alertMessage = "The hexadecimal string in your clipboard must have a length of 16 characters or less."
            }
            let alert = UIAlertController(title: "Paste Failed", message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
