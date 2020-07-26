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
        }
        //Need to format for binary representation
        else {
            newLabelValue = formatBinaryString(stringToConvert: newLabelValue ?? binaryDefaultLabel)
        }
        outputLabel.text = newLabelValue
    }

    //MARK: Button Actions
    @IBAction func numberPressed(_ sender: RoundButton) {
        
    }
    
    @IBAction func ACPressed(_ sender: RoundButton) {
        
    }
    
    @IBAction func plusMinusPressed(_ sender: RoundButton) {
        
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
    
    @IBAction func signedModeClicked(_ sender: RoundButton) {
        
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
}

//Adds state controller to the view controller
extension BinaryViewController: StateControllerProtocol {
  func setState(state: StateController) {
    self.stateController = state
  }
}
