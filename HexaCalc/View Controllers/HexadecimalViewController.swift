//
//  FirstViewController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2020-07-20.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit

class HexadecimalViewController: UIViewController {

    
    //MARK: Properties
    var stateController: StateController?
    
    @IBOutlet weak var outputLabel: UILabel!
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
    var runningNumber = ""
    var leftValue = ""
    var leftValueHex = ""
    var rightValue = ""
    var result = ""
    var currentOperation:Operation = .NULL
    
    // Current contraints are stored for the iPad such that rotating the screen allows constraints to be replaced
    var currentContraints: [NSLayoutConstraint] = []
    
    var currentlyRecognizingDoubleTap = false
    
    var secondFunctionMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Saving the original view controllers
        let originalViewControllers = tabBarController?.viewControllers
        stateController?.convValues.originalTabs = originalViewControllers
        
        outputLabel.accessibilityIdentifier = "Hexadecimal Output Label"
        updateOutputLabel(value: "0")
        
        if let savedPreferences = DataPersistence.loadPreferences() {
            
            //Remove tabs which are disabled by the user
            let arrayOfTabBarItems = tabBarController?.tabBar.items
            var removeHexTab = false
            if let barItems = arrayOfTabBarItems, barItems.count > 0 {
                if (savedPreferences.hexTabState == false) {
                    removeHexTab = true
                }
                if (savedPreferences.binTabState == false) {
                    var viewControllers = tabBarController?.viewControllers
                    viewControllers?.remove(at: 1)
                    tabBarController?.viewControllers = viewControllers
                }
                if (savedPreferences.decTabState == false) {
                    if (savedPreferences.binTabState == false) {
                        var viewControllers = tabBarController?.viewControllers
                        viewControllers?.remove(at: 1)
                        tabBarController?.viewControllers = viewControllers
                    }
                    else {
                        var viewControllers = tabBarController?.viewControllers
                        viewControllers?.remove(at: 2)
                        tabBarController?.viewControllers = viewControllers
                    }
                }
                if (removeHexTab == true) {
                    //Remove hexadecimal tab after setting state values
                    stateController?.convValues.setCalculatorTextColour = savedPreferences.setCalculatorTextColour
                    stateController?.convValues.colour = savedPreferences.colour
                    stateController?.convValues.copyActionIndex = savedPreferences.copyActionIndex
                    stateController?.convValues.pasteActionIndex = savedPreferences.pasteActionIndex
                    var viewControllers = tabBarController?.viewControllers
                    viewControllers?.remove(at: 0)
                    tabBarController?.viewControllers = viewControllers
                }
            }
            
            PLUSBtn.backgroundColor = savedPreferences.colour
            SUBBtn.backgroundColor = savedPreferences.colour
            MULTBtn.backgroundColor = savedPreferences.colour
            DIVBtn.backgroundColor = savedPreferences.colour
            EQUALSBtn.backgroundColor = savedPreferences.colour
            
            setupCalculatorTextColour(state: savedPreferences.setCalculatorTextColour, colourToSet: savedPreferences.colour)
            
            stateController?.convValues.setCalculatorTextColour = savedPreferences.setCalculatorTextColour
            stateController?.convValues.colour = savedPreferences.colour
            stateController?.convValues.copyActionIndex = savedPreferences.copyActionIndex
            stateController?.convValues.pasteActionIndex = savedPreferences.pasteActionIndex
        }

        //Setup gesture recognizers
        self.setupOutputLabelGestureRecognizers()
    }
    
    override func viewDidLayoutSubviews() {
        // Setup Hexadecimal View Controller constraints
        let screenWidth = view.bounds.width
        let screenHeight = view.bounds.height
        
        let hStacks = [hexHStack1!, hexHStack2!, hexHStack3!, hexHStack4!, hexHStack5!, hexHStack6!]
        let singleButtons = [XORBtn!, ORBtn!, ANDBtn!, NOTBtn!, DIVBtn!, MULTBtn!, SUBBtn!, PLUSBtn!, EQUALSBtn!,
                             Btn0!, Btn1!, Btn2!, Btn3!, Btn4!, Btn5!, Btn6!, Btn7!, Btn8!, Btn9!,
                             ABtn!, BBtn!, CBtn!, DBtn!, EBtn!, FBtn!, SecondFunctionBtn!]
        let doubleButtons = [ACBtn!, DELBtn!]
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            let stackConstraints = UIHelper.iPadSetupStackConstraints(hStacks: hStacks, vStack: hexVStack, outputLabel: outputLabel, screenWidth: screenWidth, screenHeight: screenHeight)
            currentContraints.append(contentsOf: stackConstraints)
            
            let buttonConstraints = UIHelper.iPadSetupButtonConstraints(singleButtons: singleButtons, doubleButtons: doubleButtons, screenWidth: screenWidth, screenHeight: screenHeight, calculator: 1)
            currentContraints.append(contentsOf: buttonConstraints)
            
            let labelConstraints = UIHelper.iPadSetupLabelConstraints(label: outputLabel!, screenWidth: screenWidth, screenHeight: screenHeight, calculator: 1)
            currentContraints.append(contentsOf: labelConstraints)
            
            NSLayoutConstraint.activate(currentContraints)
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
    //Load the current converted value from either of the other calculator screens
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ((stateController?.convValues.largerThan64Bits)!) {
            updateOutputLabel(value: "Error! Integer Overflow!")
        }
        else {
            var newLabelValue = stateController?.convValues.hexVal.uppercased()
            
            if (newLabelValue == "0"){
                updateOutputLabel(value: "0")
                runningNumber = ""
                leftValue = ""
                leftValueHex = ""
                rightValue = ""
                currentOperation = .NULL
            }
            else {
                //Need special case to convert negative values
                if (newLabelValue!.contains("-")){
                    newLabelValue = formatNegativeHex(hexToConvert: newLabelValue ?? "0").uppercased()
                }
                runningNumber = newLabelValue ?? "0"
                currentOperation = .NULL
                updateOutputLabel(value: newLabelValue ?? "0")
            }
        }
        
        //Set button colour based on state controller
        if (stateController?.convValues.colour != nil){
            PLUSBtn.backgroundColor = stateController?.convValues.colour
            SUBBtn.backgroundColor = stateController?.convValues.colour
            MULTBtn.backgroundColor = stateController?.convValues.colour
            DIVBtn.backgroundColor = stateController?.convValues.colour
            EQUALSBtn.backgroundColor = stateController?.convValues.colour
            outputLabel.textColor = stateController?.convValues.colour
        }
        
        // Small optimization to only delay single tap if absolutely necessary
        if (((stateController?.convValues.copyActionIndex == 1 || stateController?.convValues.pasteActionIndex == 1) && currentlyRecognizingDoubleTap == false) ||
            ((stateController?.convValues.copyActionIndex != 1 && stateController?.convValues.pasteActionIndex != 1) && currentlyRecognizingDoubleTap == true)) {
            outputLabel.gestureRecognizers?.forEach(outputLabel.removeGestureRecognizer)
            self.setupOutputLabelGestureRecognizers()
        }
        
        //Set calculator text colour
        setupCalculatorTextColour(state: stateController?.convValues.setCalculatorTextColour ?? false, colourToSet: stateController?.convValues.colour ?? UIColor.systemGreen)
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
            currentOutput = outputLabel.text ?? "0"
        }

        let pasteboard = UIPasteboard.general
        pasteboard.string = currentOutput
        
        // Alert the user that the output was copied to their clipboard
        let alert = UIAlertController(title: "Copied to Clipboard", message: currentOutput + " has been added to your clipboard.", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func pasteSelected() {
        let alert = UIAlertController(title: "Paste from Clipboard", message: "Press confirm to paste the contents of your clipboard into HexaCalc.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {_ in self.pasteFromClipboardToHexadecimalCalculator()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func copyAndPasteSelected() {
        let alert = UIAlertController(title: "Select Clipboard Action", message: "Press the action that you would like to perform.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: {_ in self.copySelected()}))
        alert.addAction(UIAlertAction(title: "Paste", style: .default, handler: {_ in self.pasteFromClipboardToHexadecimalCalculator()}))
        
        self.present(alert, animated: true)
    }
    
    // Function to get and format content from clipboard
    func pasteFromClipboardToHexadecimalCalculator() {
        var pastedInput = ""
        let pasteboard = UIPasteboard.general
        pastedInput = pasteboard.string ?? "0"
        
        // Validate input is a hexadecimal value
        let chars = CharacterSet(charactersIn: "0123456789ABCDEF").inverted
        var strippedSpacesHexadecimal =  pastedInput.components(separatedBy: .whitespacesAndNewlines).joined()
        let isValidHexadecimal = strippedSpacesHexadecimal.uppercased().rangeOfCharacter(from: chars) == nil
        // Strip leading zeros
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
            // Alert the user why the paste failed
            let alert = UIAlertController(title: "Paste Failed", message: alertMessage, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    // Function to handle a swipe
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
        //Button not available during error state
        if (stateController?.convValues.largerThan64Bits == true){
            return
        }
        
        if (runningNumber != "0"){
            if (runningNumber != ""){
                runningNumber.removeLast()
                // Need to be careful if runningNumber becomes empty
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
    
    @IBAction func digitPressed(_ sender: RoundButton) {
        
        if (stateController?.convValues.largerThan64Bits == true){
            runningNumber = ""
        }
        
        //Need to keep the hex value under 64 bits
        if (runningNumber.count <= 15) {
            let digit = "\(sender.tag)"
            if ((digit == "0") && (outputLabel.text == "0")) {
                //if 0 is pressed and calculator is showing 0 then do nothing
            }
            else {
                let convertedDigit = tagToHex(digitToConvert: digit)
                // Overwrite running number if it is already 0
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
        
        // Button not available during error state
        if (stateController?.convValues.largerThan64Bits == true){
            return
        }
        
        var currentValue = runningNumber
        if (runningNumber == ""){
            currentValue = outputLabel.text ?? "0"
        }
        
        let castInt = UInt64(currentValue, radix: 16)!
        let onesComplimentInt = ~castInt
        
        runningNumber = String(onesComplimentInt, radix: 16).uppercased()
        
        updateOutputLabel(value: runningNumber)
        
        quickUpdateStateController()
    }
    
    @IBAction func dividePressed(_ sender: RoundButton) {
        if secondFunctionMode {
            // 2's compliment pressed
            // Button not available during error state or when the value is 0
            if (stateController?.convValues.largerThan64Bits == true || runningNumber == ""){
                return
            }
            
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
            // Left shift pressed
            operation(operation: .LeftShift)
        }
        else {
            operation(operation: .Subtract)
        }
    }
    
    @IBAction func plusPressed(_ sender: RoundButton) {
        if secondFunctionMode {
            // Right shift pressed
            operation(operation: .RightShift)
        }
        else {
            operation(operation: .Add)
        }
    }
    
    @IBAction func equalsPressed(_ sender: RoundButton) {
        operation(operation: currentOperation)
    }
    
    //MARK: Private Functions
    
    private func operation(operation: Operation) {
        if currentOperation != .NULL {
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
                    
                    //Check for an oveflow
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

                    //Check for an overflow
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
                    
                    //Check for an overflow
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
                    //Output Error! if division by 0
                    if Int(rightValue)! == 0 {
                        result = "Error!"
                        updateOutputLabel(value: result)
                        currentOperation = operation
                        return
                    }
                    result = "\(Int(Double(leftValue)!.truncatingRemainder(dividingBy: Double(rightValue)!)))"
                    
                case .Divide:
                    //Output Error! if division by 0
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
                    
                //Should not occur
                default:
                    fatalError("Unexpected Operation...")
                }
                
                leftValue = result
                setupStateControllerValues()
                
                let hexRepresentation = stateController?.convValues.hexVal ?? "0"
                var newLabelValue = hexRepresentation.uppercased()
                leftValueHex = newLabelValue
                if ((hexRepresentation.contains("-"))){
                    newLabelValue = formatNegativeHex(hexToConvert: newLabelValue).uppercased()
                }
                updateOutputLabel(value: newLabelValue)
            }
            currentOperation = operation
        }
        else {
            //If string is empty it should be interpreted as a 0
            let binLeftValue = hexToBin(hexToConvert: runningNumber)
            if (runningNumber == "") {
                if (leftValue == "") {
                    leftValue = "0"
                    leftValueHex = "0"
                }
            }
            else {
                leftValueHex = runningNumber
                if (binLeftValue.first == "1" && binLeftValue.count == 64){
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
    //Perform a quick update to keep the state controller variables in sync with the calculator label
    private func quickUpdateStateController() {
        
        if (runningNumber.count < 17){
            stateController?.convValues.largerThan64Bits = false
        }
        
        //Need to keep the state controller updated with what is on the screen
        stateController?.convValues.hexVal = runningNumber
        //Need to convert differently if binary is positive or negative
        var binCurrentVal = ""
        var decCurrentVal = ""
        //We are dealing with a negative number
        if ((!outputLabel.text!.first!.isNumber || ((outputLabel.text!.first == "9") || (outputLabel.text!.first == "8"))) && (outputLabel.text!.count == 16)){
            //Need to perform special operation here
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
    
    //Helper function to convert the button tags to hex digits
    private func tagToHex(digitToConvert: String) -> String {
        var result = ""
        if (Int(digitToConvert)! < 10){
            result = digitToConvert
        }
        else {
            if (Int(digitToConvert)! == 10) {
                result = "A"
            }
            else if (Int(digitToConvert)! == 11) {
                result = "B"
            }
            else if (Int(digitToConvert)! == 12) {
                result = "C"
            }
            else if (Int(digitToConvert)! == 13) {
                result = "D"
            }
            else if (Int(digitToConvert)! == 14) {
                result = "E"
            }
            else if (Int(digitToConvert)! == 15) {
                result = "F"
            }
            else {
                //Should not occur ...
            }
        }
        return result
    }
    
    //Helper function to convert hex to binary
    private func hexToBin(hexToConvert: String) -> String {
        var result = ""
        var copy = hexToConvert.uppercased()
        
        if (hexToConvert == ""){
            return hexToConvert
        }
        
        for _ in 0..<hexToConvert.count {
            let currentDigit = copy.first
            copy.removeFirst()
            
            switch currentDigit {
            case "0":
                result += "0000"
            case "1":
                result += "0001"
            case "2":
                result += "0010"
            case "3":
                result += "0011"
            case "4":
                result += "0100"
            case "5":
                result += "0101"
            case "6":
                result += "0110"
            case "7":
                result += "0111"
            case "8":
                result += "1000"
            case "9":
                result += "1001"
            case "A":
                result += "1010"
            case "B":
                result += "1011"
            case "C":
                result += "1100"
            case "D":
                result += "1101"
            case "E":
                result += "1110"
            case "F":
                result += "1111"
            default:
                fatalError("Unexpected Operation...")
            }
        }
        
        return result
    }
    //Helper function to convert negative hexadecimal number to sign extended equivalent
    private func formatNegativeHex(hexToConvert: String) -> String {
        var manipulatedString = hexToConvert
        manipulatedString.removeFirst()
        
        //Special hex representation of integer min
        if (manipulatedString == "8000000000000000"){
            return manipulatedString
        }
        
        //Need to convert the binary, then flip all the bits, add 1 and convert back to hex
        let binaryInitial = String(Int(manipulatedString, radix:16)!, radix: 2)
        var invertedBinary = ""
        
        //Flip all bits
        for i in 0..<binaryInitial.count {
            if (binaryInitial[binaryInitial.index(binaryInitial.startIndex, offsetBy: i)] == "0"){
                invertedBinary += "1"
            }
            else {
                invertedBinary += "0"
            }
        }
        
        //Add 1 to the string
        let index = invertedBinary.lastIndex(of: "0") ?? (invertedBinary.endIndex)
        var newSubString = String(invertedBinary.prefix(upTo: index))
        
        
        if (newSubString.count < invertedBinary.count) {
            newSubString = newSubString + "1"
        }
        
        while (newSubString.count < invertedBinary.count) {
            newSubString = newSubString + "0"
        }
        
        //Sign extend
        while (newSubString.count < 64) {
            newSubString = "1" + newSubString
        }
        
        //Finally, convert to hexadecimal manually
        var hexResult = ""
        for _ in 0..<16 {
            //Take last 4 bits and convert to hex
            let currentIndex = newSubString.index(newSubString.endIndex, offsetBy: -4)
            let currentBinary = String(newSubString.suffix(from: currentIndex))
            newSubString.removeLast(4)
            
            switch currentBinary {
            case "0000":
                hexResult = "0" + hexResult
            case "0001":
                hexResult = "1" + hexResult
            case "0010":
                hexResult = "2" + hexResult
            case "0011":
                hexResult = "3" + hexResult
            case "0100":
                hexResult = "4" + hexResult
            case "0101":
                hexResult = "5" + hexResult
            case "0110":
                hexResult = "6" + hexResult
            case "0111":
                hexResult = "7" + hexResult
            case "1000":
                hexResult = "8" + hexResult
            case "1001":
                hexResult = "9" + hexResult
            case "1010":
                hexResult = "a" + hexResult
            case "1011":
                hexResult = "b" + hexResult
            case "1100":
                hexResult = "c" + hexResult
            case "1101":
                hexResult = "d" + hexResult
            case "1110":
                hexResult = "e" + hexResult
            case "1111":
                hexResult = "f" + hexResult
            default:
                fatalError("Unexpected Operation...")
            }
        }
        
        return hexResult
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
                    button?.setTitle("2's", for: .normal)
                case 1:
                    button?.setTitle("MOD", for: .normal)
                case 2:
                    button?.setTitle("<<X", for: .normal)
                case 3:
                    button?.setTitle(">>X", for: .normal)
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
extension HexadecimalViewController: StateControllerProtocol {
  func setState(state: StateController) {
    self.stateController = state
  }
}
