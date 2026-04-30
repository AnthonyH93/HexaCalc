//
//  ThirdViewController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2020-07-20.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit

class DecimalViewController: CalculatorViewController {

    //MARK: Properties
    @IBOutlet weak var decVStack: UIStackView!
    @IBOutlet weak var decHStack1: UIStackView!
    @IBOutlet weak var decHStack2: UIStackView!
    @IBOutlet weak var decHStack3: UIStackView!
    @IBOutlet weak var decHStack4: UIStackView!
    @IBOutlet weak var decHStack5: UIStackView!

    @IBOutlet weak var ACBtn: RoundButton!
    @IBOutlet weak var SecondFunctionBtn: RoundButton!
    @IBOutlet weak var DELBtn: RoundButton!
    @IBOutlet weak var DIVBtn: RoundButton!
    @IBOutlet weak var MULTBtn: RoundButton!
    @IBOutlet weak var SUBBtn: RoundButton!
    @IBOutlet weak var PLUSBtn: RoundButton!
    @IBOutlet weak var EQUALSBtn: RoundButton!
    @IBOutlet weak var DOTBtn: RoundButton!
    @IBOutlet weak var Btn0: RoundButton!
    @IBOutlet weak var Btn1: RoundButton!
    @IBOutlet weak var Btn2: RoundButton!
    @IBOutlet weak var Btn3: RoundButton!
    @IBOutlet weak var Btn4: RoundButton!
    @IBOutlet weak var Btn5: RoundButton!
    @IBOutlet weak var Btn6: RoundButton!
    @IBOutlet weak var Btn7: RoundButton!
    @IBOutlet weak var Btn8: RoundButton!
    @IBOutlet weak var Btn9: RoundButton!

    //MARK: Variables
    var secondFunctionMode = false

    // MARK: Abstract overrides

    override var telemetryTab: TelemetryTab { .Decimal }
    override var historyFlagReadMask: Int32 { 1 }
    override var historyFlagShift: Int32 { 0 }
    override var historyFlagClearMask: Int32 { 6 }

    override func deleteLastDigit() {
        deletePressed(DELBtn)
    }

    override func pasteFromClipboard() {
        pasteFromClipboardToDecimalCalculator()
    }

    override func copyTextFromLabel() -> String {
        if runningNumber == "" {
            let currLabel = outputLabel.text
            return (currLabel?.components(separatedBy: ",").joined(separator: ""))!
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

        outputLabel.accessibilityIdentifier = "Decimal Output Label"
        updateOutputLabel(value: "0")

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

        let hStacks = [decHStack1!, decHStack2!, decHStack3!, decHStack4!, decHStack5!]
        let singleButtons = [DIVBtn!, MULTBtn!, SUBBtn!, PLUSBtn!, EQUALSBtn!, DELBtn!, DOTBtn!, SecondFunctionBtn!,
                             ACBtn!, Btn1!, Btn2!, Btn3!, Btn4!, Btn5!, Btn6!, Btn7!, Btn8!, Btn9!]
        let doubleButtons = [Btn0!]

        if UIDevice.current.userInterfaceIdiom == .pad {
            let stackConstraints = UIHelper.iPadSetupStackConstraints(hStacks: hStacks, vStack: decVStack, outputLabel: outputLabel, screenWidth: screenWidth, screenHeight: screenHeight)
            currentConstraints.append(contentsOf: stackConstraints)

            let buttonConstraints = UIHelper.iPadSetupButtonConstraints(singleButtons: singleButtons, doubleButtons: doubleButtons, screenWidth: screenWidth, screenHeight: screenHeight, calculator: 2)
            currentConstraints.append(contentsOf: buttonConstraints)

            let labelConstraints = UIHelper.iPadSetupLabelConstraints(label: outputLabel!, screenWidth: screenWidth, screenHeight: screenHeight, calculator: 1)
            currentConstraints.append(contentsOf: labelConstraints)

            NSLayoutConstraint.activate(currentConstraints)
        }
        else {
            let stackConstraints = UIHelper.setupStackConstraints(hStacks: hStacks, vStack: decVStack, outputLabel: outputLabel, screenWidth: screenWidth)
            NSLayoutConstraint.activate(stackConstraints)

            let buttonConstraints = UIHelper.setupButtonConstraints(singleButtons: singleButtons, doubleButtons: doubleButtons, screenWidth: screenWidth, calculator: 2)
            NSLayoutConstraint.activate(buttonConstraints)

            let labelConstraints = UIHelper.setupLabelConstraints(label: outputLabel!, screenWidth: screenWidth, calculator: 1)
            NSLayoutConstraint.activate(labelConstraints)
        }
    }

    // Load the current converted value from either of the other calculator screens
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        var decimalLabelText = stateController?.convValues.decimalVal

        if (decimalLabelText != "0") {
            runningNumber = decimalLabelText ?? ""
            currentOperation = .NULL
        }
        else {
            runningNumber = ""
            leftValue = ""
            rightValue = ""
            result = ""
            currentOperation = .NULL
        }

        if ((Double(decimalLabelText ?? "0")! > 999999999 || Double(decimalLabelText ?? "0")! < -999999999) || (decimalLabelText ?? "0").contains("e")) {
            decimalLabelText = "\(Double(decimalLabelText ?? "0")!.scientificFormatted)"
        }
        else {
            if (Double(decimalLabelText ?? "0")!.truncatingRemainder(dividingBy: 1) == 0) {
                decimalLabelText = "\(Int(Double(decimalLabelText ?? "0")!))"
                if (decimalLabelText != "0") {
                    runningNumber = decimalLabelText ?? ""
                }
                decimalLabelText = self.formatDecimalString(stringToConvert: decimalLabelText ?? "0")
            }
        }

        updateOutputLabel(value: decimalLabelText ?? "0")
        setupCommonViewWillAppear()
    }

    //MARK: Button Actions
    @IBAction func numberPressed(_ sender: RoundButton) {

        var currentCopy = runningNumber
        var isNegative = false
        if (runningNumber != "" && currentCopy.removeFirst() == "-") {
            isNegative = true
        }

        if ((runningNumber.count <= 8) || (runningNumber.count == 9 && isNegative)) {
            let digit = "\(sender.tag)"
            if ((digit == "0") && (outputLabel.text == "0")) {
                //if 0 is pressed and calculator is showing 0 then do nothing
            }
            else {
                if (runningNumber == "0") {
                    runningNumber = "\(sender.tag)"
                }
                else {
                    runningNumber += "\(sender.tag)"
                }
                updateOutputLabel(value: self.formatDecimalString(stringToConvert: runningNumber))
            }

            stateController?.convValues.largerThan64Bits = false
            quickUpdateStateController()
        }
    }

    @IBAction func allClearPressed(_ sender: RoundButton) {
        runningNumber = ""
        leftValue = ""
        rightValue = ""
        result = ""
        currentOperation = .NULL
        updateOutputLabel(value: "0")

        stateController?.convValues.largerThan64Bits = false
        stateController?.convValues.decimalVal = "0"
        stateController?.convValues.hexVal = "0"
        stateController?.convValues.binVal = "0"
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

    @IBAction func deletePressed(_ sender: RoundButton) {

        if (runningNumber.contains("e")) {
            return
        }

        if (runningNumber.count == 0 || abs(Int(runningNumber) ?? 0) > 999999999) {
            //Nothing to delete
        }
        else {
            if (runningNumber.count == 1 || ((runningNumber.first == "-") && (runningNumber.count == 2)) || (runningNumber == "0.")){
                runningNumber = ""
                updateOutputLabel(value: "0")

                stateController?.convValues.largerThan64Bits = false
                stateController?.convValues.binVal = "0"
                stateController?.convValues.hexVal = "0"
                stateController?.convValues.decimalVal = "0"
            }
            else {
                runningNumber.removeLast()
                updateOutputLabel(value: self.formatDecimalString(stringToConvert: runningNumber))
                quickUpdateStateController()
            }
        }
    }

    @IBAction func dotPressed(_ sender: RoundButton) {

        if (runningNumber.contains("e")) {
            return
        }

        if runningNumber.count <= 7 && !runningNumber.contains(".") {
            if (outputLabel.text == "0" || runningNumber == "") {
                runningNumber = ""
                runningNumber = "0."
                updateOutputLabel(value: self.formatDecimalString(stringToConvert: runningNumber))
            }
            else {
                runningNumber += "."
                updateOutputLabel(value: self.formatDecimalString(stringToConvert: runningNumber))
            }

            stateController?.convValues.largerThan64Bits = false
            quickUpdateStateController()
        }
    }

    @IBAction func equalsPressed(_ sender: RoundButton) {
        operation(operation: currentOperation)

        telemetryManager.sendCalculatorSignal(tab: telemetryTab, action: TelemetryCalculatorAction.Equals)
        ReviewManager.incrementReviewWorthyCount()
    }

    @IBAction func plusPressed(_ sender: RoundButton) {
        if secondFunctionMode {
            // Squareroot pressed
            if (outputLabel.text == "0" || runningNumber == "") {
                if (outputLabel.text != "0") {
                    currentOperation = .NULL
                    let currLabel = outputLabel.text
                    let commasRemoved = (currLabel?.components(separatedBy: ",").joined(separator: ""))!
                    let currentNumber = Double(commasRemoved)!

                    if (currentNumber < 0.0) {
                        result = "Error!"
                        updateOutputLabel(value: result)
                        return
                    }

                    result = "\(sqrt(currentNumber))"
                    setupStateControllerValues()
                    stateController?.convValues.largerThan64Bits = false

                    if (Double(result)! > 999999999) {
                        let unaryCalculationResult = result == "" ? "0" : result
                        let calculationData = CalculationData(leftValue: leftValue, rightValue: "", operation: .Sqrt, result: unaryCalculationResult, isUnaryOperation: true)
                        calculationHistory.insert(calculationData, at: 0)
                        leftValue = result
                        result = "\(Double(result)!.scientificFormatted)"
                        updateOutputLabel(value: result)
                        runningNumber = result
                        quickUpdateStateController()
                        return
                    }
                    formatResult()
                    runningNumber = result

                    let unaryCalculationResult = runningNumber == "" ? "0" : runningNumber
                    let calculationData = CalculationData(leftValue: leftValue, rightValue: "", operation: .Sqrt, result: unaryCalculationResult, isUnaryOperation: true)
                    calculationHistory.insert(calculationData, at: 0)
                    leftValue = result
                    quickUpdateStateController()
                }
                else {
                    runningNumber = ""
                    updateOutputLabel(value: "0")
                }
            }
            else {
                let number = Double(runningNumber)!

                if (number < 0.0) {
                    result = "Error!"
                    updateOutputLabel(value: result)
                    return
                }

                result = "\(sqrt(number))"

                if (Double(result)! >= Double(INT64_MAX) || Double(result)! <= Double((INT64_MAX * -1) - 1)) {
                    stateController?.convValues.largerThan64Bits = true
                    stateController?.convValues.decimalVal = result
                    stateController?.convValues.binVal = "0"
                    stateController?.convValues.hexVal = "0"
                }
                else {
                    setupStateControllerValues()
                    stateController?.convValues.largerThan64Bits = false
                }

                if (Double(result)! > 999999999) {
                    let unaryCalculationResult = result == "" ? "0" : result
                    let calculationData = CalculationData(leftValue: leftValue, rightValue: "", operation: .Sqrt, result: unaryCalculationResult, isUnaryOperation: true)
                    calculationHistory.insert(calculationData, at: 0)
                    leftValue = result
                    result = "\(Double(result)!.scientificFormatted)"
                    updateOutputLabel(value: result)
                    runningNumber = result
                    quickUpdateStateController()
                    return
                }
                formatResult()
                runningNumber = result

                let unaryCalculationResult = runningNumber == "" ? "0" : runningNumber
                let calculationData = CalculationData(leftValue: leftValue, rightValue: "", operation: .Sqrt, result: unaryCalculationResult, isUnaryOperation: true)
                calculationHistory.insert(calculationData, at: 0)
                leftValue = result
                quickUpdateStateController()
            }
        }
        else {
            operation(operation: .Add)
        }
    }

    @IBAction func minusPressed(_ sender: RoundButton) {
        if secondFunctionMode {
            operation(operation: .Exp)
        }
        else {
            operation(operation: .Subtract)
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

    @IBAction func dividePressed(_ sender: RoundButton) {
        if secondFunctionMode {
            // Plus/Minus pressed
            if (outputLabel.text == "0" || runningNumber == "") {
                if (outputLabel.text != "0") {
                    currentOperation = .NULL
                    let currLabel = outputLabel.text
                    let commasRemoved = (currLabel?.components(separatedBy: ",").joined(separator: ""))!
                    var currentNumber = Double(commasRemoved)!
                    currentNumber *= -1

                    if ((currentNumber).truncatingRemainder(dividingBy: 1) == 0 && !(Double(commasRemoved)! >= Double(INT64_MAX) || Double(commasRemoved)! <= Double((INT64_MAX * -1) - 1))) {
                        runningNumber = "\(Int(currentNumber))"
                    }
                    else {
                        runningNumber = "\(currentNumber)"
                    }

                    if (runningNumber.contains("e") || (Double(runningNumber)! > 999999999 || Double(runningNumber)! < -999999999)) {
                        updateOutputLabel(value: "\(Double(runningNumber)!.scientificFormatted)")
                    }
                    else {
                        updateOutputLabel(value: self.formatDecimalString(stringToConvert: runningNumber))
                    }
                    quickUpdateStateController()
                }
                else {
                    runningNumber = ""
                    updateOutputLabel(value: "0")
                }
            }
            else {
                var number = Double(runningNumber)!
                number *= -1

                if ((number).truncatingRemainder(dividingBy: 1) == 0 && !(Double(runningNumber)! >= Double(INT64_MAX) || Double(runningNumber)! <= Double((INT64_MAX * -1) - 1))) {
                    runningNumber = "\(Int(number))"
                }
                else {
                    runningNumber = "\(number)"
                }

                if (runningNumber.contains("e") || (Double(runningNumber)! > 999999999 || Double(runningNumber)! < -999999999)) {
                    updateOutputLabel(value: "\(Double(runningNumber)!.scientificFormatted)")
                }
                else {
                    updateOutputLabel(value: self.formatDecimalString(stringToConvert: runningNumber))
                }
                quickUpdateStateController()
            }
        }
        else {
            operation(operation: .Divide)
        }
    }

    //MARK: Private Functions

    private func operation(operation: Operation) {

        if currentOperation != .NULL {
            if runningNumber != "" {
                rightValue = runningNumber
                runningNumber = ""

                switch (currentOperation) {
                case .Add:
                    result = "\(Double(leftValue)! + Double(rightValue)!)"

                case .Subtract:
                    result = "\(Double(leftValue)! - Double(rightValue)!)"

                case .Multiply:
                    result = "\(Double(leftValue)! * Double(rightValue)!)"

                case .Modulus:
                    if Double(rightValue)! == 0.0 {
                        result = "Error!"
                        updateOutputLabel(value: result)
                        currentOperation = operation
                        return
                    }
                    else {
                        result = "\(Double(leftValue)!.truncatingRemainder(dividingBy: Double(rightValue)!))"
                    }

                case .Exp:
                    result = "\(pow(Double(leftValue)!, Double(rightValue)!))"

                case .Divide:
                    if Double(rightValue)! == 0.0 {
                        result = "Error!"
                        updateOutputLabel(value: result)
                        currentOperation = operation
                        return
                    }
                    else {
                        result = "\(Double(leftValue)! / Double(rightValue)!)"
                    }

                default:
                    fatalError("Unexpected Operation...")
                }

                let calculationData = CalculationData(leftValue: leftValue, rightValue: rightValue, operation: currentOperation, result: result, isUnaryOperation: false)
                calculationHistory.insert(calculationData, at: 0)

                leftValue = result

                if (Double(result)! >= Double(INT64_MAX) || Double(result)! <= Double((INT64_MAX * -1) - 1)) {
                    stateController?.convValues.largerThan64Bits = true
                    stateController?.convValues.decimalVal = result
                    stateController?.convValues.binVal = "0"
                    stateController?.convValues.hexVal = "0"
                }
                else {
                    setupStateControllerValues()
                    stateController?.convValues.largerThan64Bits = false
                }

                if (Double(result)! > 999999999 || Double(result)! < -999999999) {
                    result = "\(Double(result)!.scientificFormatted)"
                    updateOutputLabel(value: result)
                    currentOperation = operation
                    return
                }
                formatResult()
            }

            currentOperation = operation
        }
        else {
            if runningNumber == "" {
                if (leftValue == "") {
                    leftValue = "0"
                }
            }
            else {
                leftValue = runningNumber
            }
            runningNumber = ""
            currentOperation = operation
        }
    }

    private func formatResult() {
        if (Double(result)!.truncatingRemainder(dividingBy: 1) == 0) {
            if Double(result)! >= Double(Int.max) || Double(result)! <= Double(Int.min) {
                //Cannot convert to integer in this case
            }
            else {
                result = "\(Int(Double(result)!))"
            }
            updateOutputLabel(value: self.formatDecimalString(stringToConvert: result))
        }
        else {
            if (result.count > 9 && !result.contains("e")) {
                var num = Double(result)!
                if (num < 0) { num *= -1 }
                var counter = 1
                while (num > 1) {
                    counter *= 10
                    num = num/10
                }
                var roundVal = 0
                if (counter == 1) {
                    roundVal = 100000000/(counter)
                }
                else {
                    roundVal = 1000000000/(counter)
                }
                let roundedResult = "\(Double(round(Double(roundVal) * Double(result)!)/Double(roundVal)))"

                let decimalComponents = roundedResult.components(separatedBy: ".")
                if (decimalComponents.count == 2) {
                    let chars = CharacterSet(charactersIn: "0.").inverted
                    if ((decimalComponents[1].rangeOfCharacter(from: chars) == nil)) {
                        result = decimalComponents[0]
                        stateController?.convValues.decimalVal = result
                        updateOutputLabel(value: self.formatDecimalString(stringToConvert: result))
                        return
                    }
                }
                updateOutputLabel(value: self.formatDecimalString(stringToConvert: roundedResult))
                stateController?.convValues.decimalVal = roundedResult
            }
            else {
                if (result.contains("e")) {
                    updateOutputLabel(value: "\(Double(result)!.scientificFormatted)")
                }
                else {
                    updateOutputLabel(value: self.formatDecimalString(stringToConvert: result))
                }
            }
        }
    }

    private func setupStateControllerValues() {
        stateController?.convValues.largerThan64Bits = false
        stateController?.convValues.decimalVal = result
        let hexConversion = String(Int(Double(result)!), radix: 16)
        let binConversion = String(Int(Double(result)!), radix: 2)
        stateController?.convValues.hexVal = hexConversion
        stateController?.convValues.binVal = binConversion
    }

    private func quickUpdateStateController() {
        if (runningNumber == "") { return }
        stateController?.convValues.decimalVal = runningNumber

        if (Double(runningNumber)! >= Double(INT64_MAX) || Double(runningNumber)! <= Double((INT64_MAX * -1) - 1)) {
            stateController?.convValues.largerThan64Bits = true
            stateController?.convValues.binVal = "0"
            stateController?.convValues.hexVal = "0"
        }
        else {
            let hexCurrentVal = String(Int64(Double(runningNumber)!), radix: 16)
            let binCurrentVal = String(Int64(Double(runningNumber)!), radix: 2)
            stateController?.convValues.hexVal = hexCurrentVal
            stateController?.convValues.binVal = binCurrentVal
        }
    }

    func formatDecimalString(stringToConvert: String) -> String {
        if (stringToConvert.contains("e")) {
            return stringToConvert
        }

        var stringToManipulate = stringToConvert
        var stringCopy1 = stringToConvert
        var stringCopy2 = stringToConvert
        var stringToReturn = ""
        if (stringToConvert.contains(".") || (stringCopy1.removeFirst() == "-")) {
            if (stringToConvert.contains(".") && (stringCopy2.removeFirst() == "-")) {
                stringToManipulate.remove(at: stringToManipulate.startIndex)
                let decimalComponents = stringToManipulate.components(separatedBy: ".")
                let reversed = String(decimalComponents[0].reversed())
                let commaSeperated = reversed.separate(every: 3, with: ",")
                stringToReturn = "-" + commaSeperated.reversed() + "." + decimalComponents[1]
            }
            else if (stringToConvert.contains(".")) {
                let decimalComponents = stringToConvert.components(separatedBy: ".")
                let reversed = String(decimalComponents[0].reversed())
                let commaSeperated = reversed.separate(every: 3, with: ",")
                stringToReturn = commaSeperated.reversed() + "." + decimalComponents[1]
            }
            else {
                stringToManipulate.remove(at: stringToManipulate.startIndex)
                let reversed = String(stringToManipulate.reversed())
                let commaSeperated = reversed.separate(every: 3, with: ",")
                stringToReturn = "-" + commaSeperated.reversed()
            }
        }
        else {
            let reversed = String(stringToConvert.reversed())
            let commaSeperated = reversed.separate(every: 3, with: ",")
            stringToReturn = commaSeperated.reversed() + ""
        }
        return stringToReturn
    }

    private func changeOperators(buttons: [RoundButton?], secondFunctionActive: Bool) {
        if secondFunctionActive {
            for (i, button) in buttons.enumerated() {
                switch i {
                case 0: button?.setTitle("±", for: .normal)
                case 1: button?.setTitle("MOD", for: .normal)
                case 2: button?.setTitle("xʸ", for: .normal)
                case 3: button?.setTitle("√", for: .normal)
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

    private func pasteFromClipboardToDecimalCalculator() {
        var pastedInput = ""
        let pasteboard = UIPasteboard.general
        pastedInput = pasteboard.string ?? "0"
        var isNegative = false

        if (pastedInput.first == "-") {
            isNegative = true
            pastedInput.removeFirst()
        }
        let chars = CharacterSet(charactersIn: "0123456789.").inverted
        let isValidDecimal = (pastedInput.uppercased().rangeOfCharacter(from: chars) == nil) && ((pastedInput.filter {$0 == "."}.count) < 2)
        if (isValidDecimal && pastedInput.count < 308) {
            if (pastedInput == "0") {
                runningNumber = ""
                leftValue = ""
                rightValue = ""
                result = ""
                updateOutputLabel(value: "0")
                stateController?.convValues.largerThan64Bits = false
                stateController?.convValues.decimalVal = "0"
                stateController?.convValues.hexVal = "0"
                stateController?.convValues.binVal = "0"
            }
            else {
                if (isNegative) {
                    pastedInput = "-" + pastedInput
                }
                if (Double(pastedInput)! > 999999999 || Double(pastedInput)! < -999999999) {
                    runningNumber = pastedInput
                    updateOutputLabel(value: "\(Double(pastedInput)!.scientificFormatted)")
                    quickUpdateStateController()
                }
                else {
                    if (Double(pastedInput)!.truncatingRemainder(dividingBy: 1) == 0) {
                        runningNumber = "\(Int(Double(pastedInput)!))"
                        updateOutputLabel(value: self.formatDecimalString(stringToConvert: runningNumber))
                    }
                    else {
                        if (pastedInput.count > 9) {
                            var num = Double(pastedInput)!
                            if (num < 0) { num *= -1 }
                            var counter = 1
                            while (num > 1) {
                                counter *= 10
                                num = num/10
                            }
                            var roundVal = 0
                            if (counter == 1) {
                                roundVal = 100000000/(counter)
                            }
                            else {
                                roundVal = 1000000000/(counter)
                            }
                            runningNumber = "\(Double(round(Double(roundVal) * Double(pastedInput)!)/Double(roundVal)))"
                        }
                        else {
                            runningNumber = pastedInput
                        }
                    }
                    updateOutputLabel(value: self.formatDecimalString(stringToConvert: runningNumber))
                    quickUpdateStateController()
                }
            }
        }
        else {
            var alertMessage = "Your clipboad did not contain a valid decimal string."
            if (isValidDecimal) {
                alertMessage = "The decimal string in your clipboard is too large."
            }
            let alert = UIAlertController(title: "Paste Failed", message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
