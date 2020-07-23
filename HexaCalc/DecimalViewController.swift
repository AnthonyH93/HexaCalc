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
    case NULL = "Empty"
}

class DecimalViewController: UIViewController {
    
    var stateController: StateController?
    
    //MARK: Properties
    @IBOutlet weak var outputLabel: UILabel!
    
    //MARK: Variables
    var runningNumber = ""
    var leftValue = ""
    var rightValue = ""
    var result = ""
    var currentOperation:Operation = .NULL
    
    override func viewDidLoad() {
        super.viewDidLoad()

        outputLabel.text = "0"
    }
    
    //Load the current converted value from either of the other calculator screens
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        outputLabel.text = stateController?.convValues.decimalVal
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
        }
    }
    
    @IBAction func allClearPressed(_ sender: RoundButton) {
        runningNumber = ""
        leftValue = ""
        rightValue = ""
        result = ""
        currentOperation = .NULL
        outputLabel.text = "0"
    }
    
    @IBAction func signPressed(_ sender: RoundButton) {
        
        //Essentially need to multiply the number by -1
        if (outputLabel.text == "0" || runningNumber == ""){
            runningNumber = ""
            outputLabel.text = "0"
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
        }
    }
    
    @IBAction func deletePressed(_ sender: RoundButton) {
        
        if (runningNumber.count == 0) {
            //Nothing to delete
        }
        else {
            //Need to set label to 0 when we remove last digit
            if (runningNumber.count == 1){
                runningNumber = ""
                outputLabel.text = "0"
            }
            else {
                runningNumber.removeLast()
                outputLabel.text = runningNumber
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
                
                //Setup the values for the state controller in case user changes tabs
                stateController?.convValues.decimalVal = result
                let hexConversion = String(Int(Double(result)!), radix: 16)
                let binConversion = String(Int(Double(result)!), radix: 2)
                stateController?.convValues.hexVal = hexConversion
                stateController?.convValues.binVal = binConversion
                
                if (Double(result)! > 999999999 || Double(result)! < -999999999){
                    //Need to use scientific notation for this
                    result = "\(Double(result)!.scientificFormatted)"
                    outputLabel.text = result
                    currentOperation = operation
                    return
                }
                //Find out if result is an integer
                if(Double(result)!.truncatingRemainder(dividingBy: 1) == 0) {
                    if Double(result)! > Double(Int.max) || Double(result)! < Double(Int.min) {
                        //Cannot convert to integer in this casse
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//Adds state controller to the view controller
extension DecimalViewController: StateControllerProtocol {
  func setState(state: StateController) {
    self.stateController = state
  }
}
