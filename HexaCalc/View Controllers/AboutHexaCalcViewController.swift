//
//  ExtraInformationViewController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2021-03-25.
//  Copyright © 2021 Anthony Hopkins. All rights reserved.
//

import UIKit

class AboutHexaCalcViewController: UIViewController {
    
    //MARK: Variables
    
    //let titleLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 50, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let attributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 30)!]
//        UINavigationBar.appearance().titleTextAttributes = attributes
        
        // Setup custom navigationBarItem
//        titleLabel.font = UIFont(name: "Avenir Next", size: 30)
//
//        titleLabel.text = "About HexaCalc"
//        titleLabel.numberOfLines = 2
//        titleLabel.sizeToFit()
//        titleLabel.textAlignment = .center
//
//        if let savedPreferences = DataPersistence.loadPreferences() {
//            titleLabel.textColor = savedPreferences.colour
//        }
//        else {
//            titleLabel.textColor = .systemGreen
//        }
//
//        self.navigationItem.titleView = titleLabel
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
