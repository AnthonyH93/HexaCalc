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
    let dataPersistence = DataPersistence()
    
    @IBOutlet weak var optionsLabel: UILabel!
    @IBOutlet weak var binLabel: UILabel!
    @IBOutlet weak var decLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var colourLabel: UILabel!
    @IBOutlet weak var viewPPBtn: UIButton!
    @IBOutlet weak var viewTCBtn: UIButton!
    @IBOutlet weak var thanksLabel: UILabel!
    @IBOutlet weak var setCalculatorTextColourLabel: UILabel!
    
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
    
    
    //MARK: Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup the button border widths
        redBtn.layer.borderWidth = 3
        orangeBtn.layer.borderWidth = 3
        yellowBtn.layer.borderWidth = 3
        greenBtn.layer.borderWidth = 3
        blueBtn.layer.borderWidth = 3
        tealBtn.layer.borderWidth = 3
        indigoBtn.layer.borderWidth = 3
        purpleBtn.layer.borderWidth = 3
        
        if let savedPreferences = dataPersistence.loadPreferences() {
            optionsLabel.textColor = savedPreferences.colour
            binLabel.textColor = savedPreferences.colour
            decLabel.textColor = savedPreferences.colour
            thanksLabel.textColor = savedPreferences.colour
            colourLabel.textColor = savedPreferences.colour
            settingsLabel.textColor = savedPreferences.colour
            setCalculatorTextColourLabel.textColor = savedPreferences.colour
            binSwitch.onTintColor = savedPreferences.colour
            decSwitch.onTintColor = savedPreferences.colour
            setCalculatorTextColourSwitch.onTintColor = savedPreferences.colour
            
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
            
            switch savedPreferences.colourNum {
            //Default case if the colour was never changed but a tab was
            case -1:
                
                greenBtn.layer.borderColor = UIColor.white.cgColor
                
                redBtn.layer.borderColor = UIColor.darkGray.cgColor
                orangeBtn.layer.borderColor = UIColor.darkGray.cgColor
                yellowBtn.layer.borderColor = UIColor.darkGray.cgColor
                blueBtn.layer.borderColor = UIColor.darkGray.cgColor
                tealBtn.layer.borderColor = UIColor.darkGray.cgColor
                indigoBtn.layer.borderColor = UIColor.darkGray.cgColor
                purpleBtn.layer.borderColor = UIColor.darkGray.cgColor
                
            //Red needs to be selected
            case 0:
                
                redBtn.layer.borderColor = UIColor.white.cgColor
                
                orangeBtn.layer.borderColor = UIColor.darkGray.cgColor
                yellowBtn.layer.borderColor = UIColor.darkGray.cgColor
                greenBtn.layer.borderColor = UIColor.darkGray.cgColor
                blueBtn.layer.borderColor = UIColor.darkGray.cgColor
                tealBtn.layer.borderColor = UIColor.darkGray.cgColor
                indigoBtn.layer.borderColor = UIColor.darkGray.cgColor
                purpleBtn.layer.borderColor = UIColor.darkGray.cgColor
                
            //Orange needs to be selected
            case 1:
                
                orangeBtn.layer.borderColor = UIColor.white.cgColor
                
                redBtn.layer.borderColor = UIColor.darkGray.cgColor
                yellowBtn.layer.borderColor = UIColor.darkGray.cgColor
                greenBtn.layer.borderColor = UIColor.darkGray.cgColor
                blueBtn.layer.borderColor = UIColor.darkGray.cgColor
                tealBtn.layer.borderColor = UIColor.darkGray.cgColor
                indigoBtn.layer.borderColor = UIColor.darkGray.cgColor
                purpleBtn.layer.borderColor = UIColor.darkGray.cgColor
                
            //Yellow needs to be seelcted
            case 2:
                
                yellowBtn.layer.borderColor = UIColor.white.cgColor
                
                redBtn.layer.borderColor = UIColor.darkGray.cgColor
                orangeBtn.layer.borderColor = UIColor.darkGray.cgColor
                greenBtn.layer.borderColor = UIColor.darkGray.cgColor
                blueBtn.layer.borderColor = UIColor.darkGray.cgColor
                tealBtn.layer.borderColor = UIColor.darkGray.cgColor
                indigoBtn.layer.borderColor = UIColor.darkGray.cgColor
                purpleBtn.layer.borderColor = UIColor.darkGray.cgColor
                
            //Green needs to be selected
            case 3:
                
                greenBtn.layer.borderColor = UIColor.white.cgColor
                
                redBtn.layer.borderColor = UIColor.darkGray.cgColor
                orangeBtn.layer.borderColor = UIColor.darkGray.cgColor
                yellowBtn.layer.borderColor = UIColor.darkGray.cgColor
                blueBtn.layer.borderColor = UIColor.darkGray.cgColor
                tealBtn.layer.borderColor = UIColor.darkGray.cgColor
                indigoBtn.layer.borderColor = UIColor.darkGray.cgColor
                purpleBtn.layer.borderColor = UIColor.darkGray.cgColor
                
            //Blue needs to be selected
            case 4:
                
                blueBtn.layer.borderColor = UIColor.white.cgColor
                
                redBtn.layer.borderColor = UIColor.darkGray.cgColor
                orangeBtn.layer.borderColor = UIColor.darkGray.cgColor
                yellowBtn.layer.borderColor = UIColor.darkGray.cgColor
                greenBtn.layer.borderColor = UIColor.darkGray.cgColor
                tealBtn.layer.borderColor = UIColor.darkGray.cgColor
                indigoBtn.layer.borderColor = UIColor.darkGray.cgColor
                purpleBtn.layer.borderColor = UIColor.darkGray.cgColor
                
            //Teal needs to be selected
            case 5:
                
                tealBtn.layer.borderColor = UIColor.white.cgColor
                
                redBtn.layer.borderColor = UIColor.darkGray.cgColor
                orangeBtn.layer.borderColor = UIColor.darkGray.cgColor
                yellowBtn.layer.borderColor = UIColor.darkGray.cgColor
                greenBtn.layer.borderColor = UIColor.darkGray.cgColor
                blueBtn.layer.borderColor = UIColor.darkGray.cgColor
                indigoBtn.layer.borderColor = UIColor.darkGray.cgColor
                purpleBtn.layer.borderColor = UIColor.darkGray.cgColor
                
            //Indigo needs to be selected
            case 6:
                
                indigoBtn.layer.borderColor = UIColor.white.cgColor
                
                redBtn.layer.borderColor = UIColor.darkGray.cgColor
                orangeBtn.layer.borderColor = UIColor.darkGray.cgColor
                yellowBtn.layer.borderColor = UIColor.darkGray.cgColor
                greenBtn.layer.borderColor = UIColor.darkGray.cgColor
                blueBtn.layer.borderColor = UIColor.darkGray.cgColor
                tealBtn.layer.borderColor = UIColor.darkGray.cgColor
                purpleBtn.layer.borderColor = UIColor.darkGray.cgColor
                
            //Purple needs to be selected
            case 7:
                
                purpleBtn.layer.borderColor = UIColor.white.cgColor
                
                redBtn.layer.borderColor = UIColor.darkGray.cgColor
                orangeBtn.layer.borderColor = UIColor.darkGray.cgColor
                yellowBtn.layer.borderColor = UIColor.darkGray.cgColor
                greenBtn.layer.borderColor = UIColor.darkGray.cgColor
                blueBtn.layer.borderColor = UIColor.darkGray.cgColor
                tealBtn.layer.borderColor = UIColor.darkGray.cgColor
                indigoBtn.layer.borderColor = UIColor.darkGray.cgColor
                
            default:
                fatalError("Unexpected colour identifier...")
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
    
    override func viewDidLayoutSubviews() {
        
        let screenWidth = UIScreen.main.bounds.width
        
        //iPhone SE (1st generation) special case
        if (screenWidth == 320){
            //Need to edit the font size for this screen width size
            optionsLabel?.font = UIFont(name: "Avenir Next", size: 18)
            binLabel?.font = UIFont(name: "Avenir Next", size: 18)
            decLabel?.font = UIFont(name: "Avenir Next", size: 18)
            thanksLabel?.isHidden = true
            colourLabel?.font = UIFont(name: "Avenir Next", size: 18)
            settingsLabel?.font = UIFont(name: "Avenir Next", size: 20)
            setCalculatorTextColourLabel?.font = UIFont(name: "Avenir Next", size: 18)
        }
    }
    
    //MARK: Button Actions
    @IBAction func colourPressed(_ sender: RoundButton) {
        let colourClicked = sender.self.backgroundColor
        let colourIdentifier = sender.tag
        let colourTag = "\(colourIdentifier)"
        let userPreferences = UserPreferences(colour: colourClicked!, colourNum: Int64(colourIdentifier), binTabState: binSwitch.isOn, decTabState: decSwitch.isOn, setCalculatorTextColour: setCalculatorTextColourSwitch.isOn)
        
        //Change elements onscreen to new colour
        optionsLabel.textColor = colourClicked
        binLabel.textColor = colourClicked
        decLabel.textColor = colourClicked
        thanksLabel.textColor = colourClicked
        colourLabel.textColor = colourClicked
        settingsLabel.textColor = colourClicked
        setCalculatorTextColourLabel.textColor = colourClicked
        binSwitch.onTintColor = colourClicked
        decSwitch.onTintColor = colourClicked
        setCalculatorTextColourSwitch.onTintColor = colourClicked
        
        //Set tab bar icon colour to new colour
        tabBarController?.tabBar.tintColor = colourClicked
        
        //Set state controller such that all calculators know the new colour without a reload
        stateController?.convValues.colour = colourClicked!
        stateController?.convValues.colourNum = Int64(colourIdentifier)
        
        //Change the app icon based on which colour was selected
        if (colourTag == "0") {
            changeIcon(to: "HexaCalcIconRed")
            
            redBtn.layer.borderColor = UIColor.white.cgColor
            
            orangeBtn.layer.borderColor = UIColor.darkGray.cgColor
            yellowBtn.layer.borderColor = UIColor.darkGray.cgColor
            greenBtn.layer.borderColor = UIColor.darkGray.cgColor
            blueBtn.layer.borderColor = UIColor.darkGray.cgColor
            tealBtn.layer.borderColor = UIColor.darkGray.cgColor
            indigoBtn.layer.borderColor = UIColor.darkGray.cgColor
            purpleBtn.layer.borderColor = UIColor.darkGray.cgColor
        }
        else if (colourTag == "1") {
            changeIcon(to: "HexaCalcIconOrange")
            
            orangeBtn.layer.borderColor = UIColor.white.cgColor
            
            redBtn.layer.borderColor = UIColor.darkGray.cgColor
            yellowBtn.layer.borderColor = UIColor.darkGray.cgColor
            greenBtn.layer.borderColor = UIColor.darkGray.cgColor
            blueBtn.layer.borderColor = UIColor.darkGray.cgColor
            tealBtn.layer.borderColor = UIColor.darkGray.cgColor
            indigoBtn.layer.borderColor = UIColor.darkGray.cgColor
            purpleBtn.layer.borderColor = UIColor.darkGray.cgColor
        }
        else if (colourTag == "2"){
            changeIcon(to: "HexaCalcIconYellow")
            
            yellowBtn.layer.borderColor = UIColor.white.cgColor
            
            redBtn.layer.borderColor = UIColor.darkGray.cgColor
            orangeBtn.layer.borderColor = UIColor.darkGray.cgColor
            greenBtn.layer.borderColor = UIColor.darkGray.cgColor
            blueBtn.layer.borderColor = UIColor.darkGray.cgColor
            tealBtn.layer.borderColor = UIColor.darkGray.cgColor
            indigoBtn.layer.borderColor = UIColor.darkGray.cgColor
            purpleBtn.layer.borderColor = UIColor.darkGray.cgColor
        }
        else if (colourTag == "3"){
            changeIcon(to: "HexaCalcIconGreen")
            
            greenBtn.layer.borderColor = UIColor.white.cgColor
            
            redBtn.layer.borderColor = UIColor.darkGray.cgColor
            orangeBtn.layer.borderColor = UIColor.darkGray.cgColor
            yellowBtn.layer.borderColor = UIColor.darkGray.cgColor
            blueBtn.layer.borderColor = UIColor.darkGray.cgColor
            tealBtn.layer.borderColor = UIColor.darkGray.cgColor
            indigoBtn.layer.borderColor = UIColor.darkGray.cgColor
            purpleBtn.layer.borderColor = UIColor.darkGray.cgColor
        }
        else if (colourTag == "4"){
            changeIcon(to: "HexaCalcIconBlue")
            
            blueBtn.layer.borderColor = UIColor.white.cgColor
            
            redBtn.layer.borderColor = UIColor.darkGray.cgColor
            orangeBtn.layer.borderColor = UIColor.darkGray.cgColor
            yellowBtn.layer.borderColor = UIColor.darkGray.cgColor
            greenBtn.layer.borderColor = UIColor.darkGray.cgColor
            tealBtn.layer.borderColor = UIColor.darkGray.cgColor
            indigoBtn.layer.borderColor = UIColor.darkGray.cgColor
            purpleBtn.layer.borderColor = UIColor.darkGray.cgColor
        }
        else if (colourTag == "5"){
            changeIcon(to: "HexaCalcIconTeal")
            
            tealBtn.layer.borderColor = UIColor.white.cgColor
            
            redBtn.layer.borderColor = UIColor.darkGray.cgColor
            orangeBtn.layer.borderColor = UIColor.darkGray.cgColor
            yellowBtn.layer.borderColor = UIColor.darkGray.cgColor
            greenBtn.layer.borderColor = UIColor.darkGray.cgColor
            blueBtn.layer.borderColor = UIColor.darkGray.cgColor
            indigoBtn.layer.borderColor = UIColor.darkGray.cgColor
            purpleBtn.layer.borderColor = UIColor.darkGray.cgColor
        }
        else if (colourTag == "6"){
            changeIcon(to: "HexaCalcIconIndigo")
            
            indigoBtn.layer.borderColor = UIColor.white.cgColor
            
            redBtn.layer.borderColor = UIColor.darkGray.cgColor
            orangeBtn.layer.borderColor = UIColor.darkGray.cgColor
            yellowBtn.layer.borderColor = UIColor.darkGray.cgColor
            greenBtn.layer.borderColor = UIColor.darkGray.cgColor
            blueBtn.layer.borderColor = UIColor.darkGray.cgColor
            tealBtn.layer.borderColor = UIColor.darkGray.cgColor
            purpleBtn.layer.borderColor = UIColor.darkGray.cgColor
        }
        else {
            changeIcon(to: "HexaCalcIconPurple")
            
            purpleBtn.layer.borderColor = UIColor.white.cgColor
            
            redBtn.layer.borderColor = UIColor.darkGray.cgColor
            orangeBtn.layer.borderColor = UIColor.darkGray.cgColor
            yellowBtn.layer.borderColor = UIColor.darkGray.cgColor
            greenBtn.layer.borderColor = UIColor.darkGray.cgColor
            blueBtn.layer.borderColor = UIColor.darkGray.cgColor
            tealBtn.layer.borderColor = UIColor.darkGray.cgColor
            indigoBtn.layer.borderColor = UIColor.darkGray.cgColor
        }
        
        dataPersistence.savePreferences(userPreferences: userPreferences)
    }

    //Function to toggle the binary calculator on or off when the switch is pressed
    @IBAction func binarySwitchPressed(_ sender: UISwitch) {
        if sender.isOn {
            let arrayOfTabBarItems = tabBarController?.tabBar.items
            
            let userPreferences = UserPreferences(colour: settingsLabel.textColor, colourNum: (stateController?.convValues.colourNum)!, binTabState: binSwitch.isOn, decTabState: decSwitch.isOn, setCalculatorTextColour: setCalculatorTextColourSwitch.isOn)
            dataPersistence.savePreferences(userPreferences: userPreferences)
            
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
            dataPersistence.savePreferences(userPreferences: userPreferences)
            
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
            
            let userPreferences = UserPreferences(colour: settingsLabel.textColor, colourNum: (stateController?.convValues.colourNum)!, binTabState: binSwitch.isOn, decTabState: decSwitch.isOn, setCalculatorTextColour: setCalculatorTextColourSwitch.isOn)
            dataPersistence.savePreferences(userPreferences: userPreferences)
            
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
            dataPersistence.savePreferences(userPreferences: userPreferences)
            
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
    
    //Function to toggle the optional setting of the calculator text colour
    @IBAction func setCalculatorTextColourSwitchPressed(_ sender: UISwitch) {
        //Update the stored user preferences with whatever the current switch values are: to be used in the various calcualtor tabs
        let userPreferences = UserPreferences(colour: settingsLabel.textColor, colourNum: (stateController?.convValues.colourNum)!, binTabState: binSwitch.isOn, decTabState: decSwitch.isOn, setCalculatorTextColour: setCalculatorTextColourSwitch.isOn)
        dataPersistence.savePreferences(userPreferences: userPreferences)
        stateController?.convValues.setCalculatorTextColour = setCalculatorTextColourSwitch.isOn
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
}

//Adds state controller to the view controller
extension SettingsViewController: StateControllerProtocol {
  func setState(state: StateController) {
    self.stateController = state
  }
}
