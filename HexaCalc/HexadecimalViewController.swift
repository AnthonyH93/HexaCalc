//
//  FirstViewController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2020-07-20.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit

class HexadecimalViewController: UIViewController {

    var stateController: StateController?
    @IBOutlet weak var TESTlabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Load the current converted value from either of the other calculator screens
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TESTlabel.text = stateController?.convValues.hexVal
    }

}

//Adds state controller to the view controller
extension HexadecimalViewController: StateControllerProtocol {
  func setState(state: StateController) {
    self.stateController = state
  }
}
