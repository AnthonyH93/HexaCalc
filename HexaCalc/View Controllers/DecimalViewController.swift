//
//  ThirdViewController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2020-07-20.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit

class DecimalViewController: UIViewController {
    
    //MARK: Properties
    var stateController: StateController?
    
    @IBOutlet weak var decVStack: UIStackView!
    @IBOutlet weak var decHStack1: UIStackView!
    @IBOutlet weak var decHStack2: UIStackView!
    @IBOutlet weak var decHStack3: UIStackView!
    @IBOutlet weak var decHStack4: UIStackView!
    @IBOutlet weak var decHStack5: UIStackView!
    @IBOutlet weak var outputLabel: UILabel!
    
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
    var runningNumber = ""
    var leftValue = ""
    var rightValue = ""
    var result = ""
    var currentOperation: Operation = .NULL
    
    // Current contraints are stored for the iPad such that rotating the screen allows constraints to be replaced
    var currentContraints: [NSLayoutConstraint] = []
    
    var currentlyRecognizingDoubleTap = false
    
    var secondFunctionMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        outputLabel.accessibilityIdentifier = "Decimal Output Label"
        updateOutputLabel(value: "0")
        
        if let savedPreferences = DataPersistence.loadPreferences() {
            PLUSBtn.backgroundColor = savedPreferences.colour
            SUBBtn.backgroundColor = savedPreferences.colour
            MULTBtn.backgroundColor = savedPreferences.colour
            DIVBtn.backgroundColor = savedPreferences.colour
            EQUALSBtn.backgroundColor = savedPreferences.colour
            
            setupCalculatorTextColour(state: savedPreferences.setCalculatorTextColour, colourToSet: savedPreferences.colour)
        }
        
        //Setup gesture recognizers
        self.setupOutputLabelGestureRecognizers()
    }
    
    override func viewDidLayoutSubviews() {
        // Setup Decimal View Controller constraints
        let screenWidth = view.bounds.width
        let screenHeight = view.bounds.height
        
        let hStacks = [decHStack1!, decHStack2!, decHStack3!, decHStack4!, decHStack5!]
        let singleButtons = [DIVBtn!, MULTBtn!, SUBBtn!, PLUSBtn!, EQUALSBtn!, DELBtn!, DOTBtn!, SecondFunctionBtn!,
                             ACBtn!, Btn1!, Btn2!, Btn3!, Btn4!, Btn5!, Btn6!, Btn7!, Btn8!, Btn9!]
        let doubleButtons = [Btn0!]
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            let stackConstraints = UIHelper.iPadSetupStackConstraints(hStacks: hStacks, vStack: decVStack, outputLabel: outputLabel, screenWidth: screenWidth, screenHeight: screenHeight)
            currentContraints.append(contentsOf: stackConstraints)
            
            let buttonConstraints = UIHelper.iPadSetupButtonConstraints(singleButtons: singleButtons, doubleButtons: doubleButtons, screenWidth: screenWidth, screenHeight: screenHeight, calculator: 2)
            currentContraints.append(contentsOf: buttonConstraints)
            
            let labelConstraints = UIHelper.iPadSetupLabelConstraints(label: outputLabel!, screenWidth: screenWidth, screenHeight: screenHeight, calculator: 1)
            currentContraints.append(contentsOf: labelConstraints)
            
            NSLayoutConstraint.activate(currentContraints)
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
        
        //Need to set runningNumber to the current calculation value and reset the current operation
        if (decimalLabelText != "0"){
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
        
        // Check if a conversion to scientific notation is necessary
        if ((Double(decimalLabelText ?? "0")! > 999999999 || Double(decimalLabelText ?? "0")! < -999999999) || (decimalLabelText ?? "0").contains("e")) {
            decimalLabelText = "\(Double(decimalLabelText ?? "0")!.scientificFormatted)"
        }
        else {
            // Check if we need to convert to int
            if(Double(decimalLabelText ?? "0")!.truncatingRemainder(dividingBy: 1) == 0) {
                decimalLabelText = "\(Int(Double(decimalLabelText ?? "0")!))"
                if (decimalLabelText != "0") {
                    runningNumber = decimalLabelText ?? ""
                }
                decimalLabelText = self.formatDecimalString(stringToConvert: decimalLabelText ?? "0")
            }
        }
        
        // Set button colour based on state controller
        if (stateController?.convValues.colour != nil){
            PLUSBtn.backgroundColor = stateController?.convValues.colour
            SUBBtn.backgroundColor = stateController?.convValues.colour
            MULTBtn.backgroundColor = stateController?.convValues.colour
            DIVBtn.backgroundColor = stateController?.convValues.colour
            EQUALSBtn.backgroundColor = stateController?.convValues.colour
        }
        
        // Small optimization to only delay single tap if absolutely necessary
        if (((stateController?.convValues.copyActionIndex == 1 || stateController?.convValues.pasteActionIndex == 1) && currentlyRecognizingDoubleTap == false) ||
            ((stateController?.convValues.copyActionIndex != 1 && stateController?.convValues.pasteActionIndex != 1) && currentlyRecognizingDoubleTap == true)) {
            outputLabel.gestureRecognizers?.forEach(outputLabel.removeGestureRecognizer)
            self.setupOutputLabelGestureRecognizers()
        }
        
        //Set calculator text colour
        setupCalculatorTextColour(state: stateController?.convValues.setCalculatorTextColour ?? false, colourToSet: stateController?.convValues.colour ?? UIColor.systemGreen)
        
        updateOutputLabel(value: decimalLabelText ?? "0")
    }
    
    // iPad support is for portrait and landscape mode, need to alter constraints on device rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Deactivate current contraints and remove them from the list, new constraints will be calculated and activated as device rotates
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            NSLayoutConstraint.deactivate(currentContraints)
            currentContraints.removeAll()
        }
    }
    
    @objc func labelSingleTapped(_ sender: UITapGestureRecognizer) {
        // Only perform action on single tap if user has that setting option enabled
        if (stateController?.convValues.copyActionIndex == 0 || stateController?.convValues.pasteActionIndex == 0) {
            // Decide which actions should be performed by a single tap
            if (stateController?.convValues.copyActionIndex == 0 && stateController?.convValues.pasteActionIndex == 0) {
                self.copyAndPasteSelected()
            }
            else if (stateController?.convValues.copyActionIndex == 0) {
                self.copySelected()
            }
            else {
                self.pasteSelected()
            }
        }
    }
    
    @objc func labelDoubleTapped(_ sender: UILongPressGestureRecognizer) {
        // Only perform action on double tap if user has that setting option enabled
        if (stateController?.convValues.copyActionIndex == 1 || stateController?.convValues.pasteActionIndex == 1) {
            // Decide which actions should be performed by a double tap
            if (stateController?.convValues.copyActionIndex == 1 && stateController?.convValues.pasteActionIndex == 1) {
                self.copyAndPasteSelected()
            }
            else if (stateController?.convValues.copyActionIndex == 1) {
                self.copySelected()
            }
            else {
                self.pasteSelected()
            }
        }
    }
    
    func copySelected() {
        var currentOutput = runningNumber;
        if (runningNumber == ""){
            let currLabel = outputLabel.text
            let spacesRemoved = (currLabel?.components(separatedBy: ",").joined(separator: ""))!
            currentOutput = spacesRemoved
        }

        let pasteboard = UIPasteboard.general
        pasteboard.string = currentOutput
        
        //Alert the user that the output was copied to their clipboard
        let alert = UIAlertController(title: "Copied to Clipboard", message: currentOutput + " has been added to your clipboard.", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func pasteSelected() {
        let alert = UIAlertController(title: "Paste from Clipboard", message: "Press confirm to paste the contents of your clipboard into HexaCalc.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {_ in self.pasteFromClipboardToDecimalCalculator()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func copyAndPasteSelected() {
        let alert = UIAlertController(title: "Select Clipboard Action", message: "Press the action that you would like to perform.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: {_ in self.copySelected()}))
        alert.addAction(UIAlertAction(title: "Paste", style: .default, handler: {_ in self.pasteFromClipboardToDecimalCalculator()}))
        
        self.present(alert, animated: true)
    }
    
    //Function to get and format content from clipboard
    func pasteFromClipboardToDecimalCalculator() {
        var pastedInput = ""
        let pasteboard = UIPasteboard.general
        pastedInput = pasteboard.string ?? "0"
        var isNegative = false
        
        //Validate input is a hexadecimal value
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
                if (Double(pastedInput)! > 999999999 || Double(pastedInput)! < -999999999){
                    //Need to use scientific notation for this
                    runningNumber = pastedInput
                    updateOutputLabel(value: "\(Double(pastedInput)!.scientificFormatted)")
                    quickUpdateStateController()
                }
                else {
                    if(Double(pastedInput)!.truncatingRemainder(dividingBy: 1) == 0) {
                        runningNumber = "\(Int(Double(pastedInput)!))"
                        updateOutputLabel(value: self.formatDecimalString(stringToConvert: runningNumber))
                    }
                    else {
                        if (pastedInput.count > 9){
                            //Need to round to 9 digits
                            //First find how many digits the decimal portion is
                            var num = Double(pastedInput)!
                            if (num < 0){
                                num *= -1
                            }
                            var counter = 1
                            while (num > 1){
                                counter *= 10
                                num = num/10
                            }
                            var roundVal = 0
                            if (counter == 1){
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
            //Alert the user why the paste failed
            let alert = UIAlertController(title: "Paste Failed", message: alertMessage, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    //Function to handle a swipe
    @objc func handleLabelSwipes(_ sender:UISwipeGestureRecognizer) {
        
        //Make sure the label was swiped
        guard (sender.view as? UILabel) != nil else { return }
        
        if (sender.direction == .left || sender.direction == .right) {
            deletePressed(DELBtn)
        }
    }
    
    //Function for setting up output label gesture recognizers
    func setupOutputLabelGestureRecognizers() {
        let labelSingleTap = UITapGestureRecognizer(target: self, action: #selector(self.labelSingleTapped(_:)))
        labelSingleTap.numberOfTapsRequired = 1
        let labelDoubleTap = UITapGestureRecognizer(target: self, action: #selector(self.labelDoubleTapped(_:)))
        labelDoubleTap.numberOfTapsRequired = 2
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleLabelSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleLabelSwipes(_:)))
            
        leftSwipe.direction = .left
        rightSwipe.direction = .right

        self.outputLabel.addGestureRecognizer(leftSwipe)
        self.outputLabel.addGestureRecognizer(rightSwipe)
        self.outputLabel.isUserInteractionEnabled = true
        self.outputLabel.addGestureRecognizer(labelSingleTap)
        self.outputLabel.addGestureRecognizer(labelDoubleTap)
        
        currentlyRecognizingDoubleTap = false
        
        // Small optimization to only delay single tap if absolutely necessary
        if (stateController?.convValues.copyActionIndex == 1 || stateController?.convValues.pasteActionIndex == 1) {
            labelSingleTap.require(toFail: labelDoubleTap)
            currentlyRecognizingDoubleTap = true
        }
    }
    
    //MARK: Button Actions
    @IBAction func numberPressed(_ sender: RoundButton) {
        
        //Limit number of digits to 9
        var currentCopy = runningNumber
        var isNegative = false
        if (runningNumber != "" && currentCopy.removeFirst() == "-") {
            isNegative = true
        }
        
        if ((runningNumber.count <= 8) || (runningNumber.count == 9 && isNegative)) {
            let digit = "\(sender.tag)"
            if ((digit == "0") && (outputLabel.text == "0")){
                //if 0 is pressed and calculator is showing 0 then do nothing
            }
            else {
                // Overwrite running number if it is already 0
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
            // Change back to default operators
            self.changeOperators(buttons: operatorButtons, secondFunctionActive: false)
            SecondFunctionBtn.backgroundColor = .lightGray
        }
        else {
            // Change to second function operators
            self.changeOperators(buttons: operatorButtons, secondFunctionActive: true)
            SecondFunctionBtn.backgroundColor = .white
        }
        
        self.secondFunctionMode.toggle()
    }
    
    @IBAction func deletePressed(_ sender: RoundButton) {
        
        // Do not delete anything if the calculator is displaying a number in scientific notation
        if (runningNumber.contains("e")) {
            return
        }
        
        if (runningNumber.count == 0 || abs(Int(runningNumber) ?? 0) > 999999999) {
            //Nothing to delete
        }
        else {
            //Need to set label to 0 when we remove last digit
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
        
        // Do not allow a dot to be added if the calculator is displaying a number in scientific notation
        if (runningNumber.contains("e")) {
            return
        }
        
        //Last character cannot be a dot
        if runningNumber.count <= 7 && !runningNumber.contains(".") {
            if (outputLabel.text == "0" || runningNumber == ""){
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
    }
    
    @IBAction func plusPressed(_ sender: RoundButton) {
        if secondFunctionMode {
            // Squareroot pressed
            if (outputLabel.text == "0" || runningNumber == "") {
                if (outputLabel.text != "0"){

                    //Need to reset the current operation as we are overriding a null running number state
                    currentOperation = .NULL

                    let currLabel = outputLabel.text
                    let commasRemoved = (currLabel?.components(separatedBy: ",").joined(separator: ""))!

                    let currentNumber = Double(commasRemoved)!
                    
                    // Error - cannot squareroot a negative number
                    if (currentNumber < 0.0) {
                        result = "Error!"
                        updateOutputLabel(value: result)
                        return
                    }
                    
                    result = "\(sqrt(currentNumber))"

                    setupStateControllerValues()
                    stateController?.convValues.largerThan64Bits = false
                    
                    if (Double(result)! > 999999999){
                        // Need to use scientific notation for this
                        result = "\(Double(result)!.scientificFormatted)"
                        updateOutputLabel(value: result)
                        runningNumber = result
                        quickUpdateStateController()
                        return
                    }
                    formatResult()
                    runningNumber = result
                    quickUpdateStateController()
                }
                else {
                    runningNumber = ""
                    updateOutputLabel(value: "0")
                }
            }
            else {
                let number = Double(runningNumber)!
                
                // Error - cannot squareroot a negative number
                if (number < 0.0) {
                    result = "Error!"
                    updateOutputLabel(value: result)
                    return
                }
                
                result = "\(sqrt(number))"

                setupStateControllerValues()
                stateController?.convValues.largerThan64Bits = false
                
                if (Double(result)! > 999999999){
                    //Need to use scientific notation for this
                    result = "\(Double(result)!.scientificFormatted)"
                    updateOutputLabel(value: result)
                    runningNumber = result
                    quickUpdateStateController()
                    return
                }
                formatResult()
                runningNumber = result
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
            // Essentially need to multiply the number by -1
            if (outputLabel.text == "0" || runningNumber == ""){
                //In the case that we want to negate the currently displayed number after a calculation
                if (outputLabel.text != "0"){

                    //Need to reset the current operation as we are overriding a null running number state
                    currentOperation = .NULL

                    let currLabel = outputLabel.text
                    let commasRemoved = (currLabel?.components(separatedBy: ",").joined(separator: ""))!

                    var currentNumber = Double(commasRemoved)!
                    currentNumber *= -1

                    //Find out if number is an integer
                    if((currentNumber).truncatingRemainder(dividingBy: 1) == 0 && !(Double(commasRemoved)! >= Double(INT64_MAX) || Double(commasRemoved)! <= Double((INT64_MAX * -1) - 1))) {
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

                //Find out if number is an integer
                if((number).truncatingRemainder(dividingBy: 1) == 0 && !(Double(runningNumber)! >= Double(INT64_MAX) || Double(runningNumber)! <= Double((INT64_MAX * -1) - 1))) {
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
                    //Output Error! if division by 0
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
                    //Output Error! if division by 0
                    if Double(rightValue)! == 0.0 {
                        result = "Error!"
                        updateOutputLabel(value: result)
                        currentOperation = operation
                        return
                    }
                    else {
                        result = "\(Double(leftValue)! / Double(rightValue)!)"
                    }
                    
                //Should not occur
                default:
                    fatalError("Unexpected Operation...")
                }
                
                leftValue = result
                
                //Cannot convert to binary or hexadecimal in this case -- overflow
                if (Double(result)! >= Double(INT64_MAX) || Double(result)! <= Double((INT64_MAX * -1) - 1)){
                    stateController?.convValues.largerThan64Bits = true
                    stateController?.convValues.decimalVal = result
                    stateController?.convValues.binVal = "0"
                    stateController?.convValues.hexVal = "0"
                }
                else {
                    setupStateControllerValues()
                    stateController?.convValues.largerThan64Bits = false
                }
                
                if (Double(result)! > 999999999 || Double(result)! < -999999999){
                    //Need to use scientific notation for this
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
            //If string is empty it should be interpreted as a 0
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
    
    //Used to round and choose double or int representation
    private func formatResult(){
        //Find out if result is an integer
        if(Double(result)!.truncatingRemainder(dividingBy: 1) == 0) {
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
                //Need to round to 9 digits
                //First find how many digits the decimal portion is
                var num = Double(result)!
                if (num < 0){
                    num *= -1
                }
                var counter = 1
                while (num > 1){
                    counter *= 10
                    num = num/10
                }
                var roundVal = 0
                if (counter == 1){
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
    
    //Perform a full state controller update when a new result is calculated via an operation key
    private func setupStateControllerValues() {
        stateController?.convValues.largerThan64Bits = false
        stateController?.convValues.decimalVal = result
        let hexConversion = String(Int(Double(result)!), radix: 16)
        let binConversion = String(Int(Double(result)!), radix: 2)
        stateController?.convValues.hexVal = hexConversion
        stateController?.convValues.binVal = binConversion
    }
    
    //Perform a quick update to keep the state controller variables in sync with the calculator label
    private func quickUpdateStateController() {
        //Safety condition in the case that runningNumber is nil
        if (runningNumber == ""){
            return
        }
        //Need to keep the state controller updated with what is on the screen
        stateController?.convValues.decimalVal = runningNumber
        
        //Cannot convert to binary or hexadecimal in this case -- overflow
        if (Double(runningNumber)! >= Double(INT64_MAX) || Double(runningNumber)! <= Double((INT64_MAX * -1) - 1)){
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
    
    // Add standard comma separation that the stock iOS calculator has
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
    
    //Function to check whether the user wants the output text label colour to be the same as the overall theme
    private func setupCalculatorTextColour(state: Bool, colourToSet: UIColor){
        if (state) {
            outputLabel.textColor = colourToSet
        }
        else {
            outputLabel.textColor = UIColor.white
        }
    }
    
    // Used to change the display text of buttons for second function mode
    private func changeOperators(buttons: [RoundButton?], secondFunctionActive: Bool) {
        if secondFunctionActive {
            for (i, button) in buttons.enumerated() {
                switch i {
                case 0:
                    button?.setTitle("±", for: .normal)
                case 1:
                    button?.setTitle("MOD", for: .normal)
                case 2:
                    button?.setTitle("xʸ", for: .normal)
                case 3:
                    button?.setTitle("√", for: .normal)
                default:
                    fatalError("Index out of range")
                }
            }
        }
        else {
            for (i, button) in buttons.enumerated() {
                switch i {
                case 0:
                    button?.setTitle("÷", for: .normal)
                case 1:
                    button?.setTitle("×", for: .normal)
                case 2:
                    button?.setTitle("-", for: .normal)
                case 3:
                    button?.setTitle("+", for: .normal)
                default:
                    fatalError("Index out of range")
                }
            }
        }
    }
    
    // Standardized function to update the output label
    private func updateOutputLabel(value: String) {
        outputLabel.text = value
        outputLabel.accessibilityLabel = value
    }
}

//Adds state controller to the view controller
extension DecimalViewController: StateControllerProtocol {
  func setState(state: StateController) {
    self.stateController = state
  }
}
