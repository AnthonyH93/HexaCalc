//
//  SettingsViewController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2020-08-13.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit
import os.log

class SettingsViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var hexLabel: UILabel!
    @IBOutlet weak var binLabel: UILabel!
    @IBOutlet weak var decLabel: UILabel!
    @IBOutlet weak var tabBarLabel: UILabel!
    @IBOutlet weak var colourLabel: UILabel!
    @IBOutlet weak var viewPPBtn: UIButton!
    @IBOutlet weak var viewTCBtn: UIButton!
    @IBOutlet weak var thanksLabel: UILabel!
    
    @IBOutlet weak var hexSwitch: UISwitch!
    @IBOutlet weak var binSwitch: UISwitch!
    @IBOutlet weak var decSwitch: UISwitch!
    
    //MARK: Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedPreferences = loadPreferences() {
            hexLabel.textColor = savedPreferences.colour
            binLabel.textColor = savedPreferences.colour
            decLabel.textColor = savedPreferences.colour
            thanksLabel.textColor = savedPreferences.colour
            colourLabel.textColor = savedPreferences.colour
            tabBarLabel.textColor = savedPreferences.colour
            hexSwitch.onTintColor = savedPreferences.colour
            binSwitch.onTintColor = savedPreferences.colour
            decSwitch.onTintColor = savedPreferences.colour
        }
    }
    
    //MARK: Button Actions
    @IBAction func colourPressed(_ sender: RoundButton) {
        let colourClicked = sender.self.backgroundColor
        print(colourClicked!)
        let userPreferences = UserPreferences(colour: colourClicked!, hexTabState: true, binTabState: true, decTabState: false)
        
        //Change elements onscreen to new colour
        hexLabel.textColor = colourClicked
        binLabel.textColor = colourClicked
        decLabel.textColor = colourClicked
        thanksLabel.textColor = colourClicked
        colourLabel.textColor = colourClicked
        tabBarLabel.textColor = colourClicked
        hexSwitch.onTintColor = colourClicked
        binSwitch.onTintColor = colourClicked
        decSwitch.onTintColor = colourClicked
        
        //Set tab bar icon colour to new colour
        tabBarController?.tabBar.tintColor = colourClicked
        savePreferences(userPreferences: userPreferences)
    }
    
    //MARK: Private Methods
    private func savePreferences(userPreferences: UserPreferences) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(userPreferences, toFile: UserPreferences.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Preferences successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save preferences...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadPreferences() -> UserPreferences? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: UserPreferences.ArchiveURL.path) as? UserPreferences
    }
}
