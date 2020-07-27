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
        
        stateController?.convValues.decimalVal = "0"
        stateController?.convValues.hexVal = "0"
        stateController?.convValues.binVal = "0"
    }
    
    @IBAction func plusMinusPressed(_ sender: RoundButton) {
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
    
    @IBAction func deletePressed(_ sender: RoundButton) {
        
    }
    
    @IBAction func leftShiftPressed(_ sender: RoundButton) {
        
    }
    
    @IBAction func rightShiftPressed(_ sender: RoundButton) {
        
    }
    
    @IBAction func onesCompPressed(_ sender: RoundButton) {
        
    }
    
    @IBAction func twosCompPressed(_ sender: RoundButton) {
        
    }
    
    @IBAction func XORPressed(_ sender: RoundButton) {
        
    }
    
    @IBAction func ORPressed(_ sender: RoundButton) {
        
    }
    
    @IBAction func ANDPressed(_ sender: RoundButton) {
        
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
        
    }
    
    @IBAction func multiplyPressed(_ sender: RoundButton) {
        
    }
    
    @IBAction func minusPressed(_ sender: RoundButton) {
        
    }
    
    @IBAction func addPressed(_ sender: RoundButton) {
        
    }
    
    @IBAction func equalsPressed(_ sender: RoundButton) {
        
    }
    
    //MARK: Private Functions
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
    }
    
    //Perform a quick update to keep the state controller variables in sync with the calculator label
    private func quickUpdateStateController() {
        //Need to keep the state controller updated with what is on the screen
        stateController?.convValues.binVal = runningNumber
        //Need to convert differently if binary is positive or negative
        var hexCurrentVal = ""
        var decCurrentVal = ""
        if (outputLabel.text?.first == "1"){
            print("here")
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
