//
//  ThirdViewController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2020-07-20.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit

enum Operation:String {
    case Add = "+"
    case Subtract = "-"
    case Divide = "/"
    case Multiply = "*"
    case AND = "&"
    case OR = "|"
    case XOR = "^"
    case NULL = "Empty"
}

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
    @IBOutlet weak var PLUSMINUSBtn: RoundButton!
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
    var currentOperation:Operation = .NULL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        outputLabel.text = "0"
        
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
        
        // Setup Decimal View Controller constraints
        let screenWidth = UIScreen.main.bounds.width
        
        let hStacks = [decHStack1!, decHStack2!, decHStack3!, decHStack4!, decHStack5!]
        
        let stackConstraints = UIHelper.setupStackContraints(hStacks: hStacks, vStack: decVStack, screenWidth: screenWidth)
        NSLayoutConstraint.activate(stackConstraints)
        
        let singleButtons = [DIVBtn!, MULTBtn!, SUBBtn!, PLUSBtn!, EQUALSBtn!, DELBtn!, DOTBtn!, PLUSMINUSBtn!,
                             ACBtn!, Btn1!, Btn2!, Btn3!, Btn4!, Btn5!, Btn6!, Btn7!, Btn8!, Btn9!]
        let doubleButtons = [Btn0!]
        
        let buttonConstraints = UIHelper.setupButtonConstraints(singleButtons: singleButtons, doubleButtons: doubleButtons, tripleButton: nil, screenWidth: screenWidth, calculator: 2)
        NSLayoutConstraint.activate(buttonConstraints)
        
        let labelConstraints = UIHelper.setupLabelConstraints(label: outputLabel!, screenWidth: screenWidth)
        NSLayoutConstraint.activate(labelConstraints)
        
    }
    
    //Load the current converted value from either of the other calculator screens
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
        
        //Check if a conversion to scientific notation is necessary
        if (Double(decimalLabelText ?? "0")! > 999999999 || Double(decimalLabelText ?? "0")! < -999999999) {
            decimalLabelText = "\(Double(decimalLabelText ?? "0")!.scientificFormatted)"
        }
        else {
            //Check if we need to convert to int
            if(Double(decimalLabelText ?? "0")!.truncatingRemainder(dividingBy: 1) == 0) {
                decimalLabelText = "\(Int(Double(decimalLabelText ?? "0")!))"
            }
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
        
        outputLabel.text = decimalLabelText
    }
    
    //Function to copy current output label to clipboard when tapped
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        var currentOutput = runningNumber;
        if (runningNumber == ""){
            currentOutput = outputLabel.text ?? "0"
        }

        let pasteboard = UIPasteboard.general
        pasteboard.string = currentOutput
        
        //Alert the user that the output was copied to their clipboard
        let alert = UIAlertController(title: "Copied to Clipboard", message: currentOutput + " has been added to your clipboard.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
    
    //Function to handle a swipe
    @objc func handleLabelSwipes(_ sender:UISwipeGestureRecognizer) {
        
        //Make sure the label was swiped
        guard (sender.view as? UILabel) != nil else { return }
        
        if (sender.direction == .left || sender.direction == .right) {
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
        
        //Limit number of digits to 9
        if runningNumber.count <= 8 {
            let digit = "\(sender.tag)"
            if ((digit == "0") && (outputLabel.text == "0")){
                //if 0 is pressed and calculator is showing 0 then do nothing
            }
            else {
                runningNumber += "\(sender.tag)"
                outputLabel.text = runningNumber
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
        outputLabel.text = "0"
        
        stateController?.convValues.largerThan64Bits = false
        stateController?.convValues.decimalVal = "0"
        stateController?.convValues.hexVal = "0"
        stateController?.convValues.binVal = "0"
    }
    
    @IBAction func signPressed(_ sender: RoundButton) {
                
        //Essentially need to multiply the number by -1
        if (outputLabel.text == "0" || runningNumber == ""){
            //In the case that we want to negate the currently displayed number after a calculation
            if (outputLabel.text != "0"){
                
                //Need to reset the current operation as we are overriding a null running number state
                currentOperation = .NULL
                
                var currentNumber = Double(outputLabel.text ?? "0")!
                currentNumber *= -1
                
                //Find out if number is an integer
                if((currentNumber).truncatingRemainder(dividingBy: 1) == 0) {
                    runningNumber = "\(Int(currentNumber))"
                }
                else {
                    runningNumber = "\(currentNumber)"
                }
                outputLabel.text = runningNumber
                quickUpdateStateController()
                
            }
            else {
                runningNumber = ""
                outputLabel.text = "0"
            }
        }
        else {
            var number = Double(runningNumber)!
            number *= -1
            
            //Find out if number is an integer
            if((number).truncatingRemainder(dividingBy: 1) == 0) {
                runningNumber = "\(Int(number))"
            }
            else {
                runningNumber = "\(number)"
            }
            outputLabel.text = runningNumber
            quickUpdateStateController()
        }
    }
    
    @IBAction func deletePressed(_ sender: RoundButton) {
        
        if (runningNumber.count == 0 || abs(Int(runningNumber) ?? 0) > 999999999) {
            //Nothing to delete
        }
        else {
            //Need to set label to 0 when we remove last digit
            if (runningNumber.count == 1 || ((runningNumber.first == "-") && (runningNumber.count == 2))){
                runningNumber = ""
                outputLabel.text = "0"
                
                stateController?.convValues.largerThan64Bits = false
                stateController?.convValues.binVal = "0"
                stateController?.convValues.hexVal = "0"
                stateController?.convValues.decimalVal = "0"
            }
            else {
                runningNumber.removeLast()
                outputLabel.text = runningNumber
                quickUpdateStateController()
            }
        }
    }
    
    @IBAction func dotPressed(_ sender: RoundButton) {
        
        //Last character cannot be a dot
        if runningNumber.count <= 7 && !runningNumber.contains(".") {
            if (outputLabel.text == "0" || runningNumber == ""){
                runningNumber = ""
                runningNumber = "0."
                outputLabel.text = runningNumber
            }
            else {
                runningNumber += "."
                outputLabel.text = runningNumber
            }
            
            stateController?.convValues.largerThan64Bits = false
            quickUpdateStateController()
            
        }
    }
    
    @IBAction func equalsPressed(_ sender: RoundButton) {
        operation(operation: currentOperation)
    }
    
    @IBAction func plusPressed(_ sender: RoundButton) {
        operation(operation: .Add)
    }
    
    @IBAction func minusPressed(_ sender: RoundButton) {
        operation(operation: .Subtract)
    }
    
    @IBAction func multiplyPressed(_ sender: RoundButton) {
        operation(operation: .Multiply)
    }
    
    @IBAction func dividePressed(_ sender: RoundButton) {
        operation(operation: .Divide)
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

                case .Divide:
                    //Output Error! if division by 0
                    if Double(rightValue)! == 0.0 {
                        result = "Error!"
                        outputLabel.text = result
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
                    outputLabel.text = result
                    currentOperation = operation
                    return
                }
                formatResult()
                outputLabel.text = result
            }
            currentOperation = operation
        }
        else {
            //If string is empty it should be interpreted as a 0
            if runningNumber == "" {
                leftValue = "0"
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
        }
        else {
            if (result.count > 9){
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
                result = "\(Double(round(Double(roundVal) * Double(result)!)/Double(roundVal)))"
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
extension DecimalViewController: StateControllerProtocol {
  func setState(state: StateController) {
    self.stateController = state
  }
}
