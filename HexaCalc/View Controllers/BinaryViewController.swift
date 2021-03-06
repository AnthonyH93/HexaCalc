//
//  SecondViewController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2020-07-20.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class BinaryViewController: UIViewController {
    
    //MARK: Properties
    var stateController: StateController?
    
    let binaryDefaultLabel:String = "0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000"
    
    @IBOutlet weak var outputLabel: UILabel!
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
    var runningNumber = ""
    var leftValue = ""
    var rightValue = ""
    var result = ""
    var currentOperation:Operation = .NULL
    
    // Current contraints are stored for the iPad such that rotating the screen allows constraints to be replaced
    var currentContraints: [NSLayoutConstraint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        outputLabel.text = binaryDefaultLabel
        
        if let savedPreferences = DataPersistence.loadPreferences() {
            PLUSBtn.backgroundColor = savedPreferences.colour
            SUBBtn.backgroundColor = savedPreferences.colour
            MULTBtn.backgroundColor = savedPreferences.colour
            DIVBtn.backgroundColor = savedPreferences.colour
            EQUALSBtn.backgroundColor = savedPreferences.colour
            
            setupCalculatorTextColour(state: savedPreferences.setCalculatorTextColour, colourToSet: savedPreferences.colour)
        }
        
        //Setup gesture recognizer for user tapping the calculator screen
        self.setupOutputLabelTap()
        
        //Setup gesture recognizer of user swiping left or right on the calculator screen
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleLabelSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleLabelSwipes(_:)))
            
        leftSwipe.direction = .left
        rightSwipe.direction = .right

        outputLabel.addGestureRecognizer(leftSwipe)
        outputLabel.addGestureRecognizer(rightSwipe)
    }
    
    override func viewDidLayoutSubviews() {
        // Setup Binary View Controller constraints
        let screenWidth = view.bounds.width
        let screenHeight = view.bounds.height
        
        let hStacks = [binHStack1!, binHStack2!, binHStack3!, binHStack4!, binHStack5!]
        let singleButtons = [DIVBtn!, MULTBtn!, SUBBtn!, PLUSBtn!, EQUALSBtn!, DELBtn!, XORBtn!, ORBtn!, ANDBtn!, NOTBtn!,
                             ONESBtn!, TWOSBtn!, LSBtn!, RSBtn!, Btn0!, Btn1!, Btn00!, Btn11!]
        let doubleButtons = [ACBtn!]
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            let stackConstraints = UIHelper.iPadSetupStackConstraints(hStacks: hStacks, vStack: binVStack, outputLabel: outputLabel, screenWidth: screenWidth, screenHeight: screenHeight)
            currentContraints.append(contentsOf: stackConstraints)
            
            let buttonConstraints = UIHelper.iPadSetupButtonConstraints(singleButtons: singleButtons, doubleButtons: doubleButtons, tripleButton: nil, screenWidth: screenWidth, screenHeight: screenHeight, calculator: 2)
            currentContraints.append(contentsOf: buttonConstraints)
            
            let labelConstraints = UIHelper.iPadSetupLabelConstraints(label: outputLabel!, screenWidth: screenWidth, screenHeight: screenHeight, calculator: 2)
            currentContraints.append(contentsOf: labelConstraints)
            
            NSLayoutConstraint.activate(currentContraints)
        }
        else {
            let stackConstraints = UIHelper.setupStackConstraints(hStacks: hStacks, vStack: binVStack, outputLabel: outputLabel, screenWidth: screenWidth)
            NSLayoutConstraint.activate(stackConstraints)
            
            let buttonConstraints = UIHelper.setupButtonConstraints(singleButtons: singleButtons, doubleButtons: doubleButtons, tripleButton: nil, screenWidth: screenWidth, calculator: 2)
            NSLayoutConstraint.activate(buttonConstraints)
            
            let labelConstraints = UIHelper.setupLabelConstraints(label: outputLabel!, screenWidth: screenWidth, calculator: 2)
            NSLayoutConstraint.activate(labelConstraints)
        }
    }
    
    //Load the current converted value from either of the other calculator screens
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Check for integer overflow first
        if ((stateController?.convValues.largerThan64Bits)!) {
            outputLabel.text = "Error! Integer overflow!"
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
                //Need to format for binary representation
            else {
                //Check if the binary string is negative
                if (newLabelValue!.contains("-")) {
                    //Need to convert to signed binary notation
                    newLabelValue = formatNegativeBinaryString(stringToConvert: newLabelValue ?? binaryDefaultLabel)
                }
                runningNumber = newLabelValue ?? ""
                currentOperation = .NULL
                newLabelValue = formatBinaryString(stringToConvert: newLabelValue ?? binaryDefaultLabel)
            }
            outputLabel.text = newLabelValue
        }
        
        //Set button colour based on state controller
        if (stateController?.convValues.colour != nil){
            PLUSBtn.backgroundColor = stateController?.convValues.colour
            SUBBtn.backgroundColor = stateController?.convValues.colour
            MULTBtn.backgroundColor = stateController?.convValues.colour
            DIVBtn.backgroundColor = stateController?.convValues.colour
            EQUALSBtn.backgroundColor = stateController?.convValues.colour
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
    
    //Function to copy current output label to clipboard when tapped
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        var currentOutput = runningNumber;
        if (runningNumber == ""){
            //Need to do some processing as the binary label has extra formatting
            currentOutput = outputLabel.text ?? binaryDefaultLabel
            currentOutput = currentOutput.replacingOccurrences(of: " ", with: "")
            var end = false
            for char in currentOutput {
                if (char == "0" && end == false){
                    currentOutput.remove(at: currentOutput.startIndex)
                }
                else {
                    end = true
                }
            }
            
            if (currentOutput == ""){
                currentOutput = "0"
            }
        }

        let pasteboard = UIPasteboard.general
        pasteboard.string = currentOutput
        
        //Alert the user that the output was copied to their clipboard
        let alert = UIAlertController(title: "Copied to Clipboard", message: currentOutput + " has been added to your clipboard.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        self.present(alert, animated: true)
        
        //Send event to Firebase about copying action
        FirebaseAnalytics.Analytics.logEvent("copied_calculator_value", parameters: [
            "copied_calculator": "Binary"
            ])
    }
    
    //Function to handle a swipe
    @objc func handleLabelSwipes(_ sender:UISwipeGestureRecognizer) {
        
        //Make sure the label was swiped
        guard (sender.view as? UILabel) != nil else { return }
        
        if (sender.direction == .left || sender.direction == .right) {
            if (runningNumber != "") {
                //Send event to Firebase about swipe to delete
                FirebaseAnalytics.Analytics.logEvent("swipe_to_delete", parameters: [
                    "delete_swipe_calculator": "Binary"
                    ])
            }
            deletePressed(DELBtn)
        }
    }
    
    //Function for setting up an output label tap recognizer
    func setupOutputLabelTap() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.outputLabel.isUserInteractionEnabled = true
        self.outputLabel.addGestureRecognizer(labelTap)
    }

    //MARK: Button Actions
    @IBAction func numberPressed(_ sender: RoundButton) {
        
        if (stateController?.convValues.largerThan64Bits == true){
            runningNumber = ""
        }
        
        //Limit number of bits to 64
        if runningNumber.count <= 63 {
            let digit = "\(sender.tag)"
            if ((digit == "0" || digit == "100") && (outputLabel.text == binaryDefaultLabel)){
                //if 0 is pressed and calculator is showing 0 then do nothing
            }
            else if ((runningNumber.count == 63) && (digit == "100" || digit == "11")){
                //if 00 or 11 is pressed and there is only 1 place left to fill then do nothing
            }
            else {
                var stringToAdd = "\(sender.tag)"
                //special case for 00 as tag is 100
                if (sender.tag == 100){
                    stringToAdd = "00"
                }
                runningNumber += stringToAdd
                var newLabelValue = runningNumber
                newLabelValue = formatBinaryString(stringToConvert: newLabelValue)
                outputLabel.text = newLabelValue
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
        outputLabel.text = binaryDefaultLabel
        
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
        
        var currentLabel = outputLabel.text
        if (currentLabel == binaryDefaultLabel){
            //Do nothing
        }
        else {
            if (runningNumber != ""){
                runningNumber.removeLast()
            }
            //Need to be careful if runningNumber becomes NIL
            if (runningNumber == ""){
                stateController?.convValues.largerThan64Bits = false
                stateController?.convValues.decimalVal = "0"
                stateController?.convValues.hexVal = "0"
                stateController?.convValues.binVal = "0"
                outputLabel.text = binaryDefaultLabel
            }
            else {
                currentLabel = runningNumber
                currentLabel = formatBinaryString(stringToConvert: currentLabel ?? binaryDefaultLabel)
                outputLabel.text = currentLabel
                quickUpdateStateController()
            }
        }
        
        FirebaseAnalytics.Analytics.logEvent("delete_pressed", parameters: [
            "delete_button_calculator": "Binary"
            ])
    }
    
    //Instead of making left shift an operation, just complete it whenever it is pressed the first time (doesn't need 2 arguments)
    @IBAction func leftShiftPressed(_ sender: RoundButton) {
        
        //Button not available during error state
        if (stateController?.convValues.largerThan64Bits == true){
            return
        }
        
        //If running number is empty then it will just stay as 0
        var currentValue = ""
        if runningNumber != "" {
        if (runningNumber.first == "1" && runningNumber.count == 64){
            currentValue = String(Int64(bitPattern: UInt64(runningNumber, radix: 2)!))
        }
        else {
            currentValue = String(Int(runningNumber, radix: 2)!)
        }
            currentValue = "\(Int(currentValue)! << 1)"
            
            //Update the state controller
            stateController?.convValues.decimalVal = currentValue
            let hexConversion = String(Int(Double(currentValue)!), radix: 16)
            let binConversion = String(Int(Double(currentValue)!), radix: 2)
            stateController?.convValues.hexVal = hexConversion
            stateController?.convValues.binVal = binConversion
            
            var newLabelValue = binConversion
            if ((binConversion.contains("-"))){
                newLabelValue = formatNegativeBinaryString(stringToConvert: binConversion)
            }
            runningNumber = newLabelValue
            newLabelValue = formatBinaryString(stringToConvert: newLabelValue)
            outputLabel.text = newLabelValue
        }
    }
    
    //Instead of making right shift an operation, just complete it whenever it is pressed the first time (doesn't need 2 arguments)
    @IBAction func rightShiftPressed(_ sender: RoundButton) {
        
        //Button not available during error state
        if (stateController?.convValues.largerThan64Bits == true){
            return
        }
        
        //If running number is empty then it will just stay as 0
        var currentValue = ""
        if runningNumber != "" {
        if (runningNumber.first == "1" && runningNumber.count == 64){
            currentValue = String(Int64(bitPattern: UInt64(runningNumber, radix: 2)!))
        }
        else {
            currentValue = String(Int(runningNumber, radix: 2)!)
        }
            currentValue = "\(Int(currentValue)! >> 1)"
            
            //Update the state controller
            stateController?.convValues.decimalVal = currentValue
            let hexConversion = String(Int(Double(currentValue)!), radix: 16)
            let binConversion = String(Int(Double(currentValue)!), radix: 2)
            stateController?.convValues.hexVal = hexConversion
            stateController?.convValues.binVal = binConversion
            
            var newLabelValue = binConversion
            if ((binConversion.contains("-"))){
                newLabelValue = formatNegativeBinaryString(stringToConvert: binConversion)
            }
            runningNumber = newLabelValue
            newLabelValue = formatBinaryString(stringToConvert: newLabelValue)
            outputLabel.text = newLabelValue
        }
    }
    
    //Ones compliment involves flipping all the bits
    @IBAction func onesCompPressed(_ sender: RoundButton) {
        
        //Button not available during error state
        if (stateController?.convValues.largerThan64Bits == true){
            return
        }
        
        let currLabel = outputLabel.text
        let spacesRemoved = (currLabel?.components(separatedBy: " ").joined(separator: ""))!
        var newString = ""
        //Flip all bits
        for i in 0..<spacesRemoved.count {
            if (spacesRemoved[spacesRemoved.index(spacesRemoved.startIndex, offsetBy: i)] == "0"){
                newString += "1"
            }
            else {
                newString += "0"
            }
        }
        
        //Check if new value is negative or positive
        if (newString.first == "1" && newString.count == 64){
            runningNumber = newString
        }
        else {
            let asInt = Int(newString)
            let removedLeadingZeroes = "\(asInt ?? 0)"
            runningNumber = removedLeadingZeroes
        }
        var newLabelValue = newString
        newLabelValue = formatBinaryString(stringToConvert: newLabelValue)
        outputLabel.text = newLabelValue
        
        quickUpdateStateController()
    }
    
    //Twos complement involves flipping all the bits and then adding 1
    @IBAction func twosCompPressed(_ sender: RoundButton) {
        
        //Button not available during error state
        if (stateController?.convValues.largerThan64Bits == true){
            return
        }
        
        //First flip all the bits
        let currLabel = outputLabel.text
        let spacesRemoved = (currLabel?.components(separatedBy: " ").joined(separator: ""))!
        var newString = ""
        
        for i in 0..<spacesRemoved.count {
            if (spacesRemoved[spacesRemoved.index(spacesRemoved.startIndex, offsetBy: i)] == "0"){
                newString += "1"
            }
            else {
                newString += "0"
            }
        }
        
        //Add 1 to the current value
        let index = newString.lastIndex(of: "0") ?? (newString.endIndex)
        var newSubString = String(newString.prefix(upTo: index))
        
        if (newSubString.count < newString.count) {
            newSubString = newSubString + "1"
        }
        
        while (newSubString.count < newString.count) {
            newSubString = newSubString + "0"
        }
        
        //Check if new value is negative or positive
        if (newSubString.first == "1" && newSubString.count == 64){
            runningNumber = newSubString
        }
        else {
            let asInt = Int(newSubString)
            let removedLeadingZeroes = "\(asInt ?? 0)"
            runningNumber = removedLeadingZeroes
        }
        var newLabelValue = newSubString
        newLabelValue = formatBinaryString(stringToConvert: newLabelValue)
        outputLabel.text = newLabelValue
        
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
        
        //Button not available during error state
        if (stateController?.convValues.largerThan64Bits == true){
            return
        }
        
        //Just flip all the bits
        let currLabel = outputLabel.text
        let spacesRemoved = (currLabel?.components(separatedBy: " ").joined(separator: ""))!
        var newString = ""
        //Flip all bits
        for i in 0..<spacesRemoved.count {
            if (spacesRemoved[spacesRemoved.index(spacesRemoved.startIndex, offsetBy: i)] == "0"){
                newString += "1"
            }
            else {
                newString += "0"
            }
        }
        
        //Check if new value is negative or positive
        if (newString.first == "1" && newString.count == 64){
            runningNumber = newString
        }
        else {
            let asInt = Int(newString)
            let removedLeadingZeroes = "\(asInt ?? 0)"
            runningNumber = removedLeadingZeroes
        }
        var newLabelValue = newString
        newLabelValue = formatBinaryString(stringToConvert: newLabelValue)
        outputLabel.text = newLabelValue
        
        quickUpdateStateController()
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
        FirebaseAnalytics.Analytics.logEvent("equals_pressed", parameters: [
            "equals_button_calculator": "Binary"
            ])
        operation(operation: currentOperation)
    }
    
    //MARK: Private Functions
    private func operation(operation: Operation) {
        if currentOperation != .NULL {
            if runningNumber != "" {
                if (runningNumber.first == "1" && runningNumber.count == 64){
                    rightValue = String(Int64(bitPattern: UInt64(runningNumber, radix: 2)!))
                }
                else {
                    rightValue = String(Int(runningNumber, radix: 2)!)
                }
                runningNumber = ""
                
                switch (currentOperation) {
                case .Add:
                    
                    //Check for an oveflow
                    let overCheck = Int64(leftValue)!.addingReportingOverflow(Int64(rightValue)!)
                    if (overCheck.overflow) {
                        result = "Error! Integer Overflow!"
                        outputLabel.text = result
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
                        outputLabel.text = result
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
                        outputLabel.text = result
                        currentOperation = operation
                        stateController?.convValues.largerThan64Bits = true
                        stateController?.convValues.decimalVal = "0"
                        return
                    }
                    else {
                        result = "\(Int(leftValue)! * Int(rightValue)!)"
                    }
                    
                case .Divide:
                    //Output Error! if division by 0
                    if Int(rightValue)! == 0 {
                        result = "Error!"
                        outputLabel.text = result
                        currentOperation = operation
                        return
                    }
                    let overCheck = Int64(leftValue)!.dividedReportingOverflow(by: Int64(rightValue)!)
                    if (overCheck.overflow) {
                        result = "Error! Integer Overflow!"
                        outputLabel.text = result
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
                
                //Should not occur
                default:
                    fatalError("Unexpected Operation...")
                }
                
                leftValue = result
                setupStateControllerValues()
                
                let binaryRepresentation = stateController?.convValues.binVal ?? binaryDefaultLabel
                var newLabelValue = binaryRepresentation
                if ((binaryRepresentation.contains("-"))){
                    newLabelValue = formatNegativeBinaryString(stringToConvert: binaryRepresentation)
                }
                newLabelValue = formatBinaryString(stringToConvert: newLabelValue)
                outputLabel.text = newLabelValue
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
                if (runningNumber.first == "1" && runningNumber.count == 64){
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
        while (manipulatedStringToConvert.count < 64){
            manipulatedStringToConvert = "0" + manipulatedStringToConvert
        }
        return manipulatedStringToConvert.separate(every: 4, with: " ")
    }
    
    func formatNegativeBinaryString(stringToConvert: String) -> String {
        var manipulatedStringToConvert = stringToConvert
        manipulatedStringToConvert.removeFirst()
        var newString = ""
        
        //Flip all bits
        for i in 0..<manipulatedStringToConvert.count {
            if (manipulatedStringToConvert[manipulatedStringToConvert.index(manipulatedStringToConvert.startIndex, offsetBy: i)] == "0"){
                newString += "1"
            }
            else {
                newString += "0"
            }
        }
        
        //Add 1 to the string
        let index = newString.lastIndex(of: "0") ?? (newString.endIndex)
        var newSubString = String(newString.prefix(upTo: index))
        
        
        if (newSubString.count < newString.count) {
            newSubString = newSubString + "1"
        }
        
        while (newSubString.count < newString.count) {
            newSubString = newSubString + "0"
        }
        
        //Sign extend
        while (newSubString.count < 64) {
            newSubString = "1" + newSubString
        }
        
        return newSubString
    }
    
    //Perform a full state controller update when a new result is calculated via an operation key
    private func setupStateControllerValues() {
        stateController?.convValues.decimalVal = result
        let hexConversion = String(Int(result)!, radix: 16)
        let binConversion = String(Int(result)!, radix: 2)
        stateController?.convValues.hexVal = hexConversion
        stateController?.convValues.binVal = binConversion
    }
    
    //Perform a quick update to keep the state controller variables in sync with the calculator label
    private func quickUpdateStateController() {
        
        if (runningNumber.count < 65) {
            stateController?.convValues.largerThan64Bits = false
        }
        
        //Need to keep the state controller updated with what is on the screen
        stateController?.convValues.binVal = runningNumber
        //Need to convert differently if binary is positive or negative
        var hexCurrentVal = ""
        var decCurrentVal = ""
        if (outputLabel.text?.first == "1"){
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
    
    //Function to check whether the user wants the output text label colour to be the same as the overall theme
    private func setupCalculatorTextColour(state: Bool, colourToSet: UIColor){
        if (state) {
            outputLabel.textColor = colourToSet
        }
        else {
            outputLabel.textColor = UIColor.white
        }
    }
}

//Adds state controller to the view controller
extension BinaryViewController: StateControllerProtocol {
  func setState(state: StateController) {
    self.stateController = state
  }
}
