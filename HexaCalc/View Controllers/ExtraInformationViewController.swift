//
//  ExtraInformationViewController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2021-03-25.
//  Copyright © 2021 Anthony Hopkins. All rights reserved.
//

import UIKit

class ExtraInformationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // turn on animations
        UIView.setAnimationsEnabled(true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // turn off animations
        UIView.setAnimationsEnabled(false)
    }
}
