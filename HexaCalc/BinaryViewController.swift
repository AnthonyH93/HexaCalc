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
    @IBOutlet weak var signedModeButton: RoundButton!
    
    //MARK: Variables
    var runningNumber = ""
    var leftValue = ""
    var rightValue = ""
    var result = ""
    var currentOperation:Operation = .NULL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        outputLabel.text = binaryDefaultLabel
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
    }

    //MARK: Button Actions
    @IBAction func numberPressed(_ sender: RoundButton) {
        
        //Limit number of bits to 63 - will be 64 if NOT pressed or negative decimal/hex value brought over
        if runningNumber.count <= 62 {
            let digit = "\(sender.tag)"
            if ((digit == "0") && (outputLabel.text == binaryDefaultLabel)){
                //if 0 is pressed and calculator is showing 0 then do nothing
            }
            else {
                runningNumber += "\(sender.tag)"
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
        
        var currentLabel = outputLabel.text
        if (currentLabel == binaryDefaultLabel){
            //Do nothing
        }
        else {
            runningNumber.removeLast()
            //Need to be careful if runningNumber becomes NIL
            if (runningNumber == ""){
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
    }
    
    //Instead of making left shift an operation, just complete it whenever it is pressed the first time (doesn't need 2 arguments)
    @IBAction func leftShiftPressed(_ sender: RoundButton) {
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
    
    @IBAction func onesCompPressed(_ sender: RoundButton) {
        
    }
    
    @IBAction func twosCompPressed(_ sender: RoundButton) {
        
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
        let asInt = Int(newString)
        let removedLeadingZeroes = "\(asInt ?? 0)"
        runningNumber = removedLeadingZeroes
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
                    result = "\(Int(leftValue)! + Int(rightValue)!)"
                    
                case .Subtract:
                result = "\(Int(leftValue)! - Int(rightValue)!)"
                    
                case .Multiply:
                    result = "\(Int(leftValue)! * Int(rightValue)!)"

                case .Divide:
                    //Output Error! if division by 0
                    if Int(rightValue)! == 0 {
                        result = "Error!"
                        outputLabel.text = result
                        currentOperation = operation
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
                leftValue = "0"
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
        let hexConversion = String(Int(Double(result)!), radix: 16)
        let binConversion = String(Int(Double(result)!), radix: 2)
        stateController?.convValues.hexVal = hexConversion
        stateController?.convValues.binVal = binConversion
    }
    
    //Perform a quick update to keep the state controller variables in sync with the calculator label
    private func quickUpdateStateController() {
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
}

//Adds state controller to the view controller
extension BinaryViewController: StateControllerProtocol {
  func setState(state: StateController) {
    self.stateController = state
  }
}
