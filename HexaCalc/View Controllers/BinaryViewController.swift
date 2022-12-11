//
//  SecondViewController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2020-07-20.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit

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
    
    var currentlyRecognizingDoubleTap = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        outputLabel.accessibilityIdentifier = "Binary Output Label"
        updateOutputLabel(value: binaryDefaultLabel)
        
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
            
            let buttonConstraints = UIHelper.iPadSetupButtonConstraints(singleButtons: singleButtons, doubleButtons: doubleButtons, screenWidth: screenWidth, screenHeight: screenHeight, calculator: 2)
            currentContraints.append(contentsOf: buttonConstraints)
            
            let labelConstraints = UIHelper.iPadSetupLabelConstraints(label: outputLabel!, screenWidth: screenWidth, screenHeight: screenHeight, calculator: 2)
            currentContraints.append(contentsOf: labelConstraints)
            
            NSLayoutConstraint.activate(currentContraints)
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
    
    //Load the current converted value from either of the other calculator screens
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Check for integer overflow first
        if ((stateController?.convValues.largerThan64Bits)!) {
            updateOutputLabel(value: "Error! Integer Overflow!")
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
            updateOutputLabel(value: newLabelValue ?? binaryDefaultLabel)
        }
        
        //Set button colour based on state controller
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
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func pasteSelected() {
        let alert = UIAlertController(title: "Paste from Clipboard", message: "Press confirm to paste the contents of your clipboard into HexaCalc.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {_ in self.pasteFromClipboardToBinaryCalculator()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func copyAndPasteSelected() {
        let alert = UIAlertController(title: "Select Clipboard Action", message: "Press the action that you would like to perform.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: {_ in self.copySelected()}))
        alert.addAction(UIAlertAction(title: "Paste", style: .default, handler: {_ in self.pasteFromClipboardToBinaryCalculator()}))
        
        self.present(alert, animated: true)
    }
    
    func pasteFromClipboardToBinaryCalculator() {
        var pastedInput = ""
        let pasteboard = UIPasteboard.general
        pastedInput = pasteboard.string ?? "0"
        
        //Validate input is a hexadecimal value
        let chars = CharacterSet(charactersIn: "01").inverted
        let strippedSpacesBinary =  pastedInput.components(separatedBy: .whitespacesAndNewlines).joined()
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
        
        //Button not available during error state
        if (stateController?.convValues.largerThan64Bits == true){
            return
        }
        
        var currentLabel = outputLabel.text
        if (currentLabel != binaryDefaultLabel){
            if (runningNumber != ""){
                runningNumber.removeLast()
                // Need to be careful if runningNumber becomes empty
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
            let hexConversion = String(Int64(currentValue)!, radix: 16)
            let binConversion = String(Int64(currentValue)!, radix: 2)
            stateController?.convValues.hexVal = hexConversion
            stateController?.convValues.binVal = binConversion
            
            var newLabelValue = binConversion
            if ((binConversion.contains("-"))){
                newLabelValue = formatNegativeBinaryString(stringToConvert: binConversion)
            }
            runningNumber = newLabelValue
            newLabelValue = formatBinaryString(stringToConvert: newLabelValue)
            updateOutputLabel(value: newLabelValue)
        }
    }
    
    //Instead of making right shift an operation, just complete it whenever it is pressed the first time (doesn't need 2 arguments)
    @IBAction func rightShiftPressed(_ sender: RoundButton) {
        
        //Button not available during error state
        if (stateController?.convValues.largerThan64Bits == true){
            return
        }
        
        //If running number is empty then it will just stay as 0
        if runningNumber != "" {
            let currLabel = outputLabel.text
            let spacesRemoved = (currLabel?.components(separatedBy: " ").joined(separator: ""))!
            let rightShifted = String(Int(UInt64(spacesRemoved.dropLast(), radix: 2)!))
            
            //Update the state controller
            stateController?.convValues.decimalVal = rightShifted
            let hexConversion = String(Int64(rightShifted)!, radix: 16)
            let binConversion = String(Int64(rightShifted)!, radix: 2)
            stateController?.convValues.hexVal = hexConversion
            stateController?.convValues.binVal = binConversion
            
            var newLabelValue = binConversion
            if ((binConversion.contains("-"))){
                newLabelValue = formatNegativeBinaryString(stringToConvert: binConversion)
            }
            runningNumber = newLabelValue
            newLabelValue = formatBinaryString(stringToConvert: newLabelValue)
            updateOutputLabel(value: newLabelValue)
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
        let castInt = UInt64(spacesRemoved, radix: 2)!
        let onesComplimentInt = ~castInt
        
        let onesComplimentString = String(onesComplimentInt, radix: 2)
        
        //Check if new value is negative or positive
        if (onesComplimentString.first == "1" && onesComplimentString.count == 64){
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
        
        quickUpdateStateController()
    }
    
    //Twos complement involves flipping all the bits and then adding 1
    @IBAction func twosCompPressed(_ sender: RoundButton) {
        
        //Button not available during error state or when the value is 0
        if (stateController?.convValues.largerThan64Bits == true || outputLabel.text == binaryDefaultLabel){
            return
        }
        
        let currLabel = outputLabel.text
        let spacesRemoved = (currLabel?.components(separatedBy: " ").joined(separator: ""))!
        let castInt = UInt64(spacesRemoved, radix: 2)!
        let twosComplimentInt = ~castInt + 1
        
        let twosComplimentString = String(twosComplimentInt, radix: 2)
        
        //Check if new value is negative or positive
        if (twosComplimentString.first == "1" && twosComplimentString.count == 64){
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
                updateOutputLabel(value: newLabelValue)
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
    
    // Standardized function to update the output label
    private func updateOutputLabel(value: String) {
        outputLabel.text = value
        outputLabel.accessibilityLabel = value
    }
}

//Adds state controller to the view controller
extension BinaryViewController: StateControllerProtocol {
  func setState(state: StateController) {
    self.stateController = state
  }
}
