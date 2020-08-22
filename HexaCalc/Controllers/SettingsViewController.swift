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
    var stateController: StateController?
    
    @IBOutlet weak var optionsLabel: UILabel!
    @IBOutlet weak var binLabel: UILabel!
    @IBOutlet weak var decLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var colourLabel: UILabel!
    @IBOutlet weak var viewPPBtn: UIButton!
    @IBOutlet weak var viewTCBtn: UIButton!
    @IBOutlet weak var thanksLabel: UILabel!
    
    @IBOutlet weak var binSwitch: UISwitch!
    @IBOutlet weak var decSwitch: UISwitch!
    
    //MARK: Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedPreferences = loadPreferences() {
            optionsLabel.textColor = savedPreferences.colour
            binLabel.textColor = savedPreferences.colour
            decLabel.textColor = savedPreferences.colour
            thanksLabel.textColor = savedPreferences.colour
            colourLabel.textColor = savedPreferences.colour
            settingsLabel.textColor = savedPreferences.colour
            binSwitch.onTintColor = savedPreferences.colour
            decSwitch.onTintColor = savedPreferences.colour
            
            if (savedPreferences.binTabState == false){
                binSwitch.isOn = false
            }
            if (savedPreferences.decTabState == false){
                decSwitch.isOn = false
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        let screenWidth = UIScreen.main.bounds.width
        
        //iPhone SE (1st generation) special case
        if (screenWidth == 320){
            //Need to edit the font size for this screen width size
            optionsLabel?.font = UIFont(name: "Avenir Next", size: 20)
            binLabel?.font = UIFont(name: "Avenir Next", size: 20)
            decLabel?.font = UIFont(name: "Avenir Next", size: 20)
            thanksLabel?.font = UIFont(name: "Avenir Next", size: 18)
            thanksLabel?.text = "Thanks for using HexaCalc!"
            colourLabel?.font = UIFont(name: "Avenir Next", size: 20)
            settingsLabel?.font = UIFont(name: "Avenir Next", size: 30)
        }
    }
    
    //MARK: Button Actions
    @IBAction func colourPressed(_ sender: RoundButton) {
        let colourClicked = sender.self.backgroundColor
        let colourTag = "\(sender.tag)"
        let userPreferences = UserPreferences(colour: colourClicked!, hexTabState: true, binTabState: binSwitch.isOn, decTabState: decSwitch.isOn)
        
        //Change elements onscreen to new colour
        optionsLabel.textColor = colourClicked
        binLabel.textColor = colourClicked
        decLabel.textColor = colourClicked
        thanksLabel.textColor = colourClicked
        colourLabel.textColor = colourClicked
        settingsLabel.textColor = colourClicked
        binSwitch.onTintColor = colourClicked
        decSwitch.onTintColor = colourClicked
        
        //Set tab bar icon colour to new colour
        tabBarController?.tabBar.tintColor = colourClicked
        
        //Set state controller such that all calculators know the new colour without a reload
        stateController?.convValues.colour = colourClicked!
        
        //Change the app icon based on which colour was selected
        if (colourTag == "0") {
            changeIcon(to: "HexaCalcIconRed")
        }
        else if (colourTag == "1") {
            changeIcon(to: "HexaCalcIconOrange")
        }
        else if (colourTag == "2"){
            changeIcon(to: "HexaCalcIconYellow")
        }
        else if (colourTag == "3"){
            changeIcon(to: "HexaCalcIconGreen")
        }
        else if (colourTag == "4"){
            changeIcon(to: "HexaCalcIconBlue")
        }
        else if (colourTag == "5"){
            changeIcon(to: "HexaCalcIconTeal")
        }
        else if (colourTag == "6"){
            changeIcon(to: "HexaCalcIconIndigo")
        }
        else {
            changeIcon(to: "HexaCalcIconPurple")
        }
        
        savePreferences(userPreferences: userPreferences)
    }

    //Function to toggle the binary calculator on or off when the switch is pressed
    @IBAction func binarySwitchPressed(_ sender: UISwitch) {
        if sender.isOn {
            let arrayOfTabBarItems = tabBarController?.tabBar.items
            
            let userPreferences = UserPreferences(colour: settingsLabel.textColor, hexTabState: true, binTabState: binSwitch.isOn, decTabState: decSwitch.isOn)
            savePreferences(userPreferences: userPreferences)
            
            if let barItems = arrayOfTabBarItems, barItems.count > 1 {
                if (barItems[1].title! != "Binary"){
                    var viewControllers = tabBarController?.viewControllers
                    viewControllers?.insert((stateController?.convValues.originalTabs?[1])!, at: 1)
                    tabBarController?.viewControllers = viewControllers
                }
            }
        }
        else {
            let arrayOfTabBarItems = tabBarController?.tabBar.items
            
            let userPreferences = UserPreferences(colour: settingsLabel.textColor, hexTabState: true, binTabState: binSwitch.isOn, decTabState: decSwitch.isOn)
            savePreferences(userPreferences: userPreferences)
            
            if let barItems = arrayOfTabBarItems, barItems.count > 2 {
                if (barItems[1].title! == "Binary"){
                    var viewControllers = tabBarController?.viewControllers
                    viewControllers?.remove(at: 1)
                    tabBarController?.viewControllers = viewControllers
                }
            }
        }
    }
    
    //Function to toggle the decimal calculator on or off when the switch is pressed
    @IBAction func decimalSwitchPressed(_ sender: UISwitch) {
        if sender.isOn {
            let arrayOfTabBarItems = tabBarController?.tabBar.items
            
            let userPreferences = UserPreferences(colour: settingsLabel.textColor, hexTabState: true, binTabState: binSwitch.isOn, decTabState: decSwitch.isOn)
            savePreferences(userPreferences: userPreferences)
            
            if let barItems = arrayOfTabBarItems, barItems.count > 1 {
                if (barItems.count == 2){
                    if (barItems[1].title! != "Decimal"){
                        var viewControllers = tabBarController?.viewControllers
                        viewControllers?.insert((stateController?.convValues.originalTabs?[2])!, at: 1)
                        tabBarController?.viewControllers = viewControllers
                    }
                }
                else if (barItems.count == 3){
                    if (barItems[1].title! != "Decimal" && barItems[2].title! != "Decimal"){
                        var viewControllers = tabBarController?.viewControllers
                        viewControllers?.insert((stateController?.convValues.originalTabs?[2])!, at: 2)
                        tabBarController?.viewControllers = viewControllers
                    }
                }
                else {
                    //Should not occur since 1 tab must have been off if the switch was off
                }
            }
        }
        else {
            let arrayOfTabBarItems = tabBarController?.tabBar.items
            
            let userPreferences = UserPreferences(colour: settingsLabel.textColor, hexTabState: true, binTabState: binSwitch.isOn, decTabState: decSwitch.isOn)
            savePreferences(userPreferences: userPreferences)
            
            if let barItems = arrayOfTabBarItems, barItems.count > 2 {
                if (barItems[2].title! == "Decimal"){
                    var viewControllers = tabBarController?.viewControllers
                    viewControllers?.remove(at: 2)
                    tabBarController?.viewControllers = viewControllers
                }
                if (barItems[1].title! == "Decimal"){
                    var viewControllers = tabBarController?.viewControllers
                    viewControllers?.remove(at: 1)
                    tabBarController?.viewControllers = viewControllers
                }
            }
        }
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
    
    
    
    //MARK: Private Methods
    private func savePreferences(userPreferences: UserPreferences) {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fullPath = paths[0].appendingPathComponent("userPreferences")

        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: userPreferences, requiringSecureCoding: false)
            try data.write(to: fullPath)
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } catch {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadPreferences() -> UserPreferences? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fullPath = paths[0].appendingPathComponent("userPreferences")
        
        if let nsData = NSData(contentsOf: fullPath) {
            do {
                
                let data = Data(referencing:nsData)

                if let loadedPreferences = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UserPreferences{
                    return loadedPreferences
                }
            } catch {
                print("Couldn't read file.")
                return nil
            }
        }
        return nil
    }
    
    func changeIcon(to iconName: String) {
      //First, need to make sure the app can change its icon
      guard UIApplication.shared.supportsAlternateIcons else {
        return
      }

      //Next we can actually work on changing the app icon
      UIApplication.shared.setAlternateIconName(iconName, completionHandler: { (error) in
        //Output the result of the icon change
        if let error = error {
          print("App icon failed to change due to \(error.localizedDescription)")
        } else {
          print("App icon changed successfully")
        }
      })
    }
}

//Adds state controller to the view controller
extension SettingsViewController: StateControllerProtocol {
  func setState(state: StateController) {
    self.stateController = state
  }
}
