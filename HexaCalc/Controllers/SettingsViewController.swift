//
//  SettingsViewController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2020-08-13.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var hexLabel: UILabel!
    @IBOutlet weak var binLabel: UIStackView!
    @IBOutlet weak var decLabel: UILabel!
    @IBOutlet weak var viewPPBtn: UIButton!
    @IBOutlet weak var viewTCBtn: UIButton!
    @IBOutlet weak var thanksLabel: UILabel!
    
    
    //MARK: Variables
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: Button Actions
    @IBAction func colourPressed(_ sender: RoundButton) {
        let colourClicked = sender.self.backgroundColor
        print(colourClicked!)
    }
    
    //MARK: Private Methods
}
