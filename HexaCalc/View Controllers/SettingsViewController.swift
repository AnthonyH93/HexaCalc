//
//  SettingsViewController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2020-08-13.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit
import os.log
import FirebaseAnalytics

class SettingsViewController: UIViewController {

    //MARK: Properties
    var stateController: StateController?
    
    @IBOutlet weak var optionsLabel: UILabel!
    @IBOutlet weak var hexLabel: UILabel!
    @IBOutlet weak var binLabel: UILabel!
    @IBOutlet weak var decLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var colourLabel: UILabel!
    @IBOutlet weak var viewPPBtn: UIButton!
    @IBOutlet weak var viewTCBtn: UIButton!
    @IBOutlet weak var thanksLabel: UILabel!
    @IBOutlet weak var setCalculatorTextColourLabel: UILabel!
    
    @IBOutlet weak var hexSwitch: UISwitch!
    @IBOutlet weak var binSwitch: UISwitch!
    @IBOutlet weak var decSwitch: UISwitch!
    @IBOutlet weak var setCalculatorTextColourSwitch: UISwitch!
    
    @IBOutlet weak var redBtn: RoundButton!
    @IBOutlet weak var orangeBtn: RoundButton!
    @IBOutlet weak var yellowBtn: RoundButton!
    @IBOutlet weak var greenBtn: RoundButton!
    @IBOutlet weak var blueBtn: RoundButton!
    @IBOutlet weak var tealBtn: RoundButton!
    @IBOutlet weak var indigoBtn: RoundButton!
    @IBOutlet weak var purpleBtn: RoundButton!
    
    @IBOutlet weak var colourButtonsStack: UIStackView!
    
    //MARK: Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let labels = [hexLabel, optionsLabel, binLabel, decLabel, thanksLabel, colourLabel, settingsLabel, setCalculatorTextColourLabel]
        let switches = [hexSwitch, binSwitch, decSwitch, setCalculatorTextColourSwitch]
        let buttons = [redBtn, orangeBtn, yellowBtn, greenBtn, blueBtn, tealBtn, indigoBtn, purpleBtn]
        
        //Setup the button border widths
        for button in buttons {
            button!.layer.borderWidth = 3
        }
        
        if let savedPreferences = DataPersistence.loadPreferences() {
            for label in labels {
                label?.textColor = savedPreferences.colour
            }
            
            for entry in switches {
                entry!.onTintColor = savedPreferences.colour
            }
            
            if (savedPreferences.binTabState == false){
                binSwitch.isOn = false
            }
            if (savedPreferences.decTabState == false){
                decSwitch.isOn = false
            }
            
            if (savedPreferences.setCalculatorTextColour == true){
                setCalculatorTextColourSwitch.isOn = true
            }
            else {
                setCalculatorTextColourSwitch.isOn = false
            }
            
            //Setup the correct button borders based on the selected colour
            stateController?.convValues.colourNum = savedPreferences.colourNum
            
            var highlightedIndex = 0
            switch savedPreferences.colourNum {
            //Default case if the colour was never changed but a tab was
            case -1:
                highlightedIndex = 3
            //Red needs to be selected
            case 0:
                highlightedIndex = 0  
            //Orange needs to be selected
            case 1:
                highlightedIndex = 1
            //Yellow needs to be seelcted
            case 2:
                highlightedIndex = 2
            //Green needs to be selected
            case 3:
                highlightedIndex = 3
            //Blue needs to be selected
            case 4:
                highlightedIndex = 4
            //Teal needs to be selected
            case 5:
                highlightedIndex = 5
            //Indigo needs to be selected
            case 6:
                highlightedIndex = 6
            //Purple needs to be selected
            case 7:
                highlightedIndex = 7
            default:
                fatalError("Unexpected colour identifier...")
            }
            
            //Set the button border colours
            buttons[highlightedIndex]!.layer.borderColor = UIColor.white.cgColor
            
            for (index, button) in buttons.enumerated() {
                if (index != highlightedIndex) {
                    button!.layer.borderColor = UIColor.darkGray.cgColor
                }
            }
        }
        else {
            //Default colour is green so outline that button only
            greenBtn.layer.borderColor = UIColor.white.cgColor
            
            redBtn.layer.borderColor = UIColor.darkGray.cgColor
            orangeBtn.layer.borderColor = UIColor.darkGray.cgColor
            yellowBtn.layer.borderColor = UIColor.darkGray.cgColor
            blueBtn.layer.borderColor = UIColor.darkGray.cgColor
            tealBtn.layer.borderColor = UIColor.darkGray.cgColor
            indigoBtn.layer.borderColor = UIColor.darkGray.cgColor
            purpleBtn.layer.borderColor = UIColor.darkGray.cgColor
            
            stateController?.convValues.colourNum = -1
        }
    }
    
    //MARK: Button Actions
    @IBAction func colourPressed(_ sender: RoundButton) {
        let colourClicked = sender.self.backgroundColor
        let colourIdentifier = sender.tag
        let colourTag = "\(colourIdentifier)"
        let userPreferences = UserPreferences(colour: colourClicked!, colourNum: Int64(colourIdentifier), binTabState: binSwitch.isOn, decTabState: decSwitch.isOn, setCalculatorTextColour: setCalculatorTextColourSwitch.isOn)
        
        let labels = [hexLabel, optionsLabel, binLabel, decLabel, thanksLabel, colourLabel, settingsLabel, setCalculatorTextColourLabel]
        let switches = [hexSwitch, binSwitch, decSwitch, setCalculatorTextColourSwitch]
        let buttons = [redBtn, orangeBtn, yellowBtn, greenBtn, blueBtn, tealBtn, indigoBtn, purpleBtn]
        
        //Change elements onscreen to new colour
        for label in labels {
            label?.textColor = colourClicked
        }
        
        for entry in switches {
            entry!.onTintColor = colourClicked
        }

        setCalculatorTextColourSwitch.onTintColor = colourClicked
        
        //Set tab bar icon colour to new colour
        tabBarController?.tabBar.tintColor = colourClicked
        
        //Set state controller such that all calculators know the new colour without a reload
        stateController?.convValues.colour = colourClicked!
        stateController?.convValues.colourNum = Int64(colourIdentifier)
        
        let colourString = getColourStringFromID(id: colourIdentifier)
        //Send event to Firebase about colour changing
        FirebaseAnalytics.Analytics.logEvent("colour_changed", parameters: [
            "colour_set": colourString as String
            ])
        
        var highlightedIndex = 0
        //Change the app icon based on which colour was selected
        if (colourTag == "0") {
            changeIcon(to: "HexaCalcIconRed")
            highlightedIndex = 0
        }
        else if (colourTag == "1") {
            changeIcon(to: "HexaCalcIconOrange")
            highlightedIndex = 1
        }
        else if (colourTag == "2"){
            changeIcon(to: "HexaCalcIconYellow")
            highlightedIndex = 2
        }
        else if (colourTag == "3"){
            changeIcon(to: "HexaCalcIconGreen")
            highlightedIndex = 3
        }
        else if (colourTag == "4"){
            changeIcon(to: "HexaCalcIconBlue")
            highlightedIndex = 4
        }
        else if (colourTag == "5"){
            changeIcon(to: "HexaCalcIconTeal")
            highlightedIndex = 5
        }
        else if (colourTag == "6"){
            changeIcon(to: "HexaCalcIconIndigo")
            highlightedIndex = 6
        }
        else {
            changeIcon(to: "HexaCalcIconPurple")
            highlightedIndex = 7
        }
        
        //Set the button border colours
        buttons[highlightedIndex]!.layer.borderColor = UIColor.white.cgColor
        
        for (index, button) in buttons.enumerated() {
            if (index != highlightedIndex) {
                button!.layer.borderColor = UIColor.darkGray.cgColor
            }
        }
        
        DataPersistence.savePreferences(userPreferences: userPreferences)
    }

    //Function to toggle the binary calculator on or off when the switch is pressed
    @IBAction func binarySwitchPressed(_ sender: UISwitch) {
        if sender.isOn {
            let arrayOfTabBarItems = tabBarController?.tabBar.items
            
            let userPreferences = UserPreferences(colour: settingsLabel.textColor, colourNum: (stateController?.convValues.colourNum)!, binTabState: binSwitch.isOn, decTabState: decSwitch.isOn, setCalculatorTextColour: setCalculatorTextColourSwitch.isOn)
            DataPersistence.savePreferences(userPreferences: userPreferences)
            
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
            
            let userPreferences = UserPreferences(colour: settingsLabel.textColor, colourNum: (stateController?.convValues.colourNum)!, binTabState: binSwitch.isOn, decTabState: decSwitch.isOn, setCalculatorTextColour: setCalculatorTextColourSwitch.isOn)
            DataPersistence.savePreferences(userPreferences: userPreferences)
            
            if let barItems = arrayOfTabBarItems, barItems.count > 2 {
                if (barItems[1].title! == "Binary"){
                    var viewControllers = tabBarController?.viewControllers
                    viewControllers?.remove(at: 1)
                    tabBarController?.viewControllers = viewControllers
                }
            }
        }
        
        //Send event to Firebase about switch being pressed
        FirebaseAnalytics.Analytics.logEvent("binary_switch_pressed", parameters: [
            "binary_switch_new_state": sender.isOn ? "Turned On" : "Turned Off" as String
            ])
    }
    
    //Function to toggle the decimal calculator on or off when the switch is pressed
    @IBAction func decimalSwitchPressed(_ sender: UISwitch) {
        if sender.isOn {
            let arrayOfTabBarItems = tabBarController?.tabBar.items
            
            let userPreferences = UserPreferences(colour: settingsLabel.textColor, colourNum: (stateController?.convValues.colourNum)!, binTabState: binSwitch.isOn, decTabState: decSwitch.isOn, setCalculatorTextColour: setCalculatorTextColourSwitch.isOn)
            DataPersistence.savePreferences(userPreferences: userPreferences)
            
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
            
            let userPreferences = UserPreferences(colour: settingsLabel.textColor, colourNum: (stateController?.convValues.colourNum)!, binTabState: binSwitch.isOn, decTabState: decSwitch.isOn, setCalculatorTextColour: setCalculatorTextColourSwitch.isOn)
            DataPersistence.savePreferences(userPreferences: userPreferences)
            
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
        
        //Send event to Firebase about switch being pressed
        FirebaseAnalytics.Analytics.logEvent("decimal_switch_pressed", parameters: [
            "decimal_switch_new_state": sender.isOn ? "Turned On" : "Turned Off" as String
            ])
    }
    
    //Function to toggle the optional setting of the calculator text colour
    @IBAction func setCalculatorTextColourSwitchPressed(_ sender: UISwitch) {
        //Update the stored user preferences with whatever the current switch values are: to be used in the various calcualtor tabs
        let userPreferences = UserPreferences(colour: settingsLabel.textColor, colourNum: (stateController?.convValues.colourNum)!, binTabState: binSwitch.isOn, decTabState: decSwitch.isOn, setCalculatorTextColour: setCalculatorTextColourSwitch.isOn)
        DataPersistence.savePreferences(userPreferences: userPreferences)
        stateController?.convValues.setCalculatorTextColour = setCalculatorTextColourSwitch.isOn
        
        //Send event to Firebase about switch being pressed
        FirebaseAnalytics.Analytics.logEvent("coloured_text_switch_pressed", parameters: [
            "colour_switch_new_state": sender.isOn ? "Turned On" : "Turned Off" as String
            ])
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
    
    //MARK: Private Functions
    
    //Function to change the app icon to one of the preloaded options
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
    
    func getColourStringFromID(id: Int) -> String {
        var colourString = ""
        
        switch id {
        case 0:
            colourString = "Red"
        case 1:
            colourString = "Orange"
        case 2:
            colourString = "Yellow"
        case 3:
            colourString = "Green"
        case 4:
            colourString = "Blue"
        case 5:
            colourString = "Teal"
        case 6:
            colourString = "Indigo"
        case 7:
            colourString = "Violet"
        default:
            colourString = "Error"
        }
        
        return colourString
    }
}

//Adds state controller to the view controller
extension SettingsViewController: StateControllerProtocol {
  func setState(state: StateController) {
    self.stateController = state
  }
}
