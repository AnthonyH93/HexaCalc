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
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        
        let screenWidth = UIScreen.main.bounds.width
        
        //iPhone SE (1st generation) special case
        if (screenWidth == 320){
           setupSEConstraints()
        }
        //All other screensizes can use these constraints
        else {
            let constraints = [
                hexVStack.widthAnchor.constraint(equalToConstant: 350),
                hexVStack.heightAnchor.constraint(equalToConstant: 420),
                hexHStack1.widthAnchor.constraint(equalToConstant: 350),
                hexHStack1.heightAnchor.constraint(equalToConstant: 65),
                hexHStack2.widthAnchor.constraint(equalToConstant: 350),
                hexHStack2.heightAnchor.constraint(equalToConstant: 65),
                hexHStack3.widthAnchor.constraint(equalToConstant: 350),
                hexHStack3.heightAnchor.constraint(equalToConstant: 65),
                hexHStack4.widthAnchor.constraint(equalToConstant: 350),
                hexHStack4.heightAnchor.constraint(equalToConstant: 65),
                hexHStack5.widthAnchor.constraint(equalToConstant: 350),
                hexHStack5.heightAnchor.constraint(equalToConstant: 65),
                hexHStack6.widthAnchor.constraint(equalToConstant: 350),
                hexHStack6.heightAnchor.constraint(equalToConstant: 65)
            ]
            NSLayoutConstraint.activate(constraints)
        }
        
    }
    //Load the current converted value from either of the other calculator screens
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        outputLabel.text = stateController?.convValues.hexVal.uppercased()
    }
    
    //MARK: Private Functions
    
    //Helper function to set custon layout for iPhone SE screen size
    func setupSEConstraints(){
        let oldConstraints = [
            outputLabel.widthAnchor.constraint(equalToConstant: 350),
            outputLabel.heightAnchor.constraint(equalToConstant: 64),
            ACBtn.widthAnchor.constraint(equalToConstant: 205),
            ACBtn.heightAnchor.constraint(equalToConstant: 65),
            DELBtn.widthAnchor.constraint(equalToConstant: 135),
            DELBtn.heightAnchor.constraint(equalToConstant: 65),
            XORBtn.widthAnchor.constraint(equalToConstant: 65),
            XORBtn.heightAnchor.constraint(equalToConstant: 65),
            ORBtn.widthAnchor.constraint(equalToConstant: 65),
            ORBtn.heightAnchor.constraint(equalToConstant: 65),
            ANDBtn.widthAnchor.constraint(equalToConstant: 65),
            ANDBtn.heightAnchor.constraint(equalToConstant: 65),
            NOTBtn.widthAnchor.constraint(equalToConstant: 65),
            NOTBtn.heightAnchor.constraint(equalToConstant: 65),
            DIVBtn.widthAnchor.constraint(equalToConstant: 65),
            DIVBtn.heightAnchor.constraint(equalToConstant: 65),
            CBtn.widthAnchor.constraint(equalToConstant: 65),
            CBtn.heightAnchor.constraint(equalToConstant: 65),
            DBtn.widthAnchor.constraint(equalToConstant: 65),
            DBtn.heightAnchor.constraint(equalToConstant: 65),
            EBtn.widthAnchor.constraint(equalToConstant: 65),
            EBtn.heightAnchor.constraint(equalToConstant: 65),
            FBtn.widthAnchor.constraint(equalToConstant: 65),
            FBtn.heightAnchor.constraint(equalToConstant: 65),
            MULTBtn.widthAnchor.constraint(equalToConstant: 65),
            MULTBtn.heightAnchor.constraint(equalToConstant: 65),
            ABtn.widthAnchor.constraint(equalToConstant: 65),
            ABtn.heightAnchor.constraint(equalToConstant: 65),
            BBtn.widthAnchor.constraint(equalToConstant: 65),
            BBtn.heightAnchor.constraint(equalToConstant: 65),
            SUBBtn.widthAnchor.constraint(equalToConstant: 65),
            SUBBtn.heightAnchor.constraint(equalToConstant: 65),
            PLUSBtn.widthAnchor.constraint(equalToConstant: 65),
            PLUSBtn.heightAnchor.constraint(equalToConstant: 65),
            EQUALSBtn.widthAnchor.constraint(equalToConstant: 65),
            EQUALSBtn.heightAnchor.constraint(equalToConstant: 65),
            Btn0.widthAnchor.constraint(equalToConstant: 65),
            Btn0.heightAnchor.constraint(equalToConstant: 65),
            Btn1.widthAnchor.constraint(equalToConstant: 65),
            Btn1.heightAnchor.constraint(equalToConstant: 65),
            Btn2.widthAnchor.constraint(equalToConstant: 65),
            Btn2.heightAnchor.constraint(equalToConstant: 65),
            Btn3.widthAnchor.constraint(equalToConstant: 65),
            Btn3.heightAnchor.constraint(equalToConstant: 65),
            Btn4.widthAnchor.constraint(equalToConstant: 65),
            Btn4.heightAnchor.constraint(equalToConstant: 65),
            Btn5.widthAnchor.constraint(equalToConstant: 65),
            Btn5.heightAnchor.constraint(equalToConstant: 65),
            Btn6.widthAnchor.constraint(equalToConstant: 65),
            Btn6.heightAnchor.constraint(equalToConstant: 65),
            Btn7.widthAnchor.constraint(equalToConstant: 65),
            Btn7.heightAnchor.constraint(equalToConstant: 65),
            Btn8.widthAnchor.constraint(equalToConstant: 65),
            Btn8.heightAnchor.constraint(equalToConstant: 65),
            Btn9.widthAnchor.constraint(equalToConstant: 65),
            Btn9.heightAnchor.constraint(equalToConstant: 65)
        ]
        
        //NSLayoutConstraint.deactivate(oldConstraints)
        for oldConstraint in oldConstraints {
            oldConstraint.isActive = false
        }
        
        let buttons = [
            Btn0,
            Btn1,
            Btn2,
            Btn3,
            Btn4,
            Btn5,
            Btn6,
            Btn7,
            Btn8,
            Btn9,
            ACBtn,
            DELBtn,
            NOTBtn,
            XORBtn,
            ORBtn,
            ANDBtn,
            DIVBtn,
            MULTBtn,
            PLUSBtn,
            SUBBtn,
            EQUALSBtn,
            ABtn,
            BBtn,
            CBtn,
            DBtn,
            EBtn,
            FBtn
        ]
        
        for button in buttons {
            button!.layer.cornerRadius = 0
            button!.titleLabel!.font = UIFont(name: "Avenir Next", size: 22)
        }
        
        
        let constraints = [
            hexVStack.widthAnchor.constraint(equalToConstant: 295),
            hexVStack.heightAnchor.constraint(equalToConstant: 330),
            outputLabel.widthAnchor.constraint(equalToConstant: 295),
            outputLabel.heightAnchor.constraint(equalToConstant: 64),
            ACBtn.widthAnchor.constraint(equalToConstant: 175),
            ACBtn.heightAnchor.constraint(equalToConstant: 50),
            DELBtn.widthAnchor.constraint(equalToConstant: 110),
            DELBtn.heightAnchor.constraint(equalToConstant: 50),
            XORBtn.widthAnchor.constraint(equalToConstant: 50),
            XORBtn.heightAnchor.constraint(equalToConstant: 50),
            ORBtn.widthAnchor.constraint(equalToConstant: 50),
            ORBtn.heightAnchor.constraint(equalToConstant: 50),
            ANDBtn.widthAnchor.constraint(equalToConstant: 50),
            ANDBtn.heightAnchor.constraint(equalToConstant: 50),
            NOTBtn.widthAnchor.constraint(equalToConstant: 50),
            NOTBtn.heightAnchor.constraint(equalToConstant: 50),
            DIVBtn.widthAnchor.constraint(equalToConstant: 50),
            DIVBtn.heightAnchor.constraint(equalToConstant: 50),
            CBtn.widthAnchor.constraint(equalToConstant: 50),
            CBtn.heightAnchor.constraint(equalToConstant: 50),
            DBtn.widthAnchor.constraint(equalToConstant: 50),
            DBtn.heightAnchor.constraint(equalToConstant: 50),
            EBtn.widthAnchor.constraint(equalToConstant: 50),
            EBtn.heightAnchor.constraint(equalToConstant: 50),
            FBtn.widthAnchor.constraint(equalToConstant: 50),
            FBtn.heightAnchor.constraint(equalToConstant: 50),
            MULTBtn.widthAnchor.constraint(equalToConstant: 50),
            MULTBtn.heightAnchor.constraint(equalToConstant: 50),
            ABtn.widthAnchor.constraint(equalToConstant: 50),
            ABtn.heightAnchor.constraint(equalToConstant: 50),
            BBtn.widthAnchor.constraint(equalToConstant: 50),
            BBtn.heightAnchor.constraint(equalToConstant: 50),
            SUBBtn.widthAnchor.constraint(equalToConstant: 50),
            SUBBtn.heightAnchor.constraint(equalToConstant: 50),
            PLUSBtn.widthAnchor.constraint(equalToConstant: 50),
            PLUSBtn.heightAnchor.constraint(equalToConstant: 50),
            EQUALSBtn.widthAnchor.constraint(equalToConstant: 50),
            EQUALSBtn.heightAnchor.constraint(equalToConstant: 50),
            Btn0.widthAnchor.constraint(equalToConstant: 50),
            Btn0.heightAnchor.constraint(equalToConstant: 50),
            Btn1.widthAnchor.constraint(equalToConstant: 50),
            Btn1.heightAnchor.constraint(equalToConstant: 50),
            Btn2.widthAnchor.constraint(equalToConstant: 50),
            Btn2.heightAnchor.constraint(equalToConstant: 50),
            Btn3.widthAnchor.constraint(equalToConstant: 50),
            Btn3.heightAnchor.constraint(equalToConstant: 50),
            Btn4.widthAnchor.constraint(equalToConstant: 50),
            Btn4.heightAnchor.constraint(equalToConstant: 50),
            Btn5.widthAnchor.constraint(equalToConstant: 50),
            Btn5.heightAnchor.constraint(equalToConstant: 50),
            Btn6.widthAnchor.constraint(equalToConstant: 50),
            Btn6.heightAnchor.constraint(equalToConstant: 50),
            Btn7.widthAnchor.constraint(equalToConstant: 50),
            Btn7.heightAnchor.constraint(equalToConstant: 50),
            Btn8.widthAnchor.constraint(equalToConstant: 50),
            Btn8.heightAnchor.constraint(equalToConstant: 50),
            Btn9.widthAnchor.constraint(equalToConstant: 50),
            Btn9.heightAnchor.constraint(equalToConstant: 50),
            hexHStack1.widthAnchor.constraint(equalToConstant: 295),
            hexHStack1.heightAnchor.constraint(equalToConstant: 50),
            hexHStack2.widthAnchor.constraint(equalToConstant: 295),
            hexHStack2.heightAnchor.constraint(equalToConstant: 50),
            hexHStack3.widthAnchor.constraint(equalToConstant: 295),
            hexHStack3.heightAnchor.constraint(equalToConstant: 50),
            hexHStack4.widthAnchor.constraint(equalToConstant: 295),
            hexHStack4.heightAnchor.constraint(equalToConstant: 50),
            hexHStack5.widthAnchor.constraint(equalToConstant: 295),
            hexHStack5.heightAnchor.constraint(equalToConstant: 50),
            hexHStack6.widthAnchor.constraint(equalToConstant: 295),
            hexHStack6.heightAnchor.constraint(equalToConstant: 50)
        ]
        for constraint in constraints {
            constraint.isActive = true
        }
    }

}

//Adds state controller to the view controller
extension HexadecimalViewController: StateControllerProtocol {
  func setState(state: StateController) {
    self.stateController = state
  }
}
