//
//  ExtraInformationViewController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2021-03-25.
//  Copyright © 2021 Anthony Hopkins. All rights reserved.
//

import UIKit

class AboutHexaCalcViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var websiteLinksLabel: UILabel!
    @IBOutlet weak var appVersionLabel1: UILabel!
    @IBOutlet weak var appVersionLabel2: UILabel!
    @IBOutlet weak var thanksLabel: UILabel!
    
    @IBOutlet weak var viewPrivacyPolicyBtn: UIButton!
    @IBOutlet weak var viewTermsAndConditionsBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let labels = [websiteLinksLabel, appVersionLabel1, appVersionLabel2, thanksLabel]
        
        if let savedPreferences = DataPersistence.loadPreferences() {
            for label in labels {
                label?.textColor = savedPreferences.colour
            }
//            viewPrivacyPolicyBtn.tintColor = savedPreferences.colour
//            viewTermsAndConditionsBtn.tintColor = savedPreferences.colour
        }
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
    
    //iOS approval requirement to have a hosted privacy policy and a button to open it within the app
    @IBAction func viewPrivacyPolicy(_ sender: Any) {
        let privacyPolicyURL = NSURL(string: "https://anthony55hopkins.wixsite.com/hexacalc/privacy-policy")! as URL
        UIApplication.shared.open(privacyPolicyURL, options: [:], completionHandler: nil)
    }
    
    //iOS approval requirement to have a hosted terms and conditions page and a button to open it within the app
    @IBAction func viewTermsAndConditions(_ sender: Any) {
        let termsAndConditionsURL = NSURL(string: "https://anthony55hopkins.wixsite.com/hexacalc/terms-conditions")! as URL
        UIApplication.shared.open(termsAndConditionsURL, options: [:], completionHandler: nil)
    }
}
