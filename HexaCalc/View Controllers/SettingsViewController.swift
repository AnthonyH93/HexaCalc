//
//  SettingsViewController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2020-08-13.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit
import os.log

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    var stateController: StateController?
    
    let sectionTitles = [ "Tab Bar",
                          "Gestures",
                          "Customization",
                          "About the app" ]
    let rowsPerSection = [3, 2, 2, 4]
    
    var actions = ["One tap", "Two tap"]
    
    let urls = [ "https://github.com/AnthonyH93/HexaCalc",
                 "https://anthony55hopkins.wixsite.com/hexacalc/privacy-policy",
                 "https://anthony55hopkins.wixsite.com/hexacalc/terms-conditions" ]
    
    var preferences = UserPreferences.getDefaultPreferences()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
        
        table.register(TextTableViewCell.self, forCellReuseIdentifier: TextTableViewCell.identifier)
        table.register(SwitchTableViewCell.nib(), forCellReuseIdentifier: SwitchTableViewCell.identifier)
        table.register(SelectionSummaryTableViewCell.self, forCellReuseIdentifier: SelectionSummaryTableViewCell.identifier)
        table.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.identifier)
        
        table.sectionHeaderHeight = 40
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        // Force dark mode to be used (for now)
        overrideUserInterfaceStyle = .dark
        
        // Check if prefereces are saved
        if let savedPreferences = DataPersistence.loadPreferences() {
            self.preferences = savedPreferences
            self.stateController?.convValues.colourNum = savedPreferences.colourNum
            self.stateController?.convValues.colour = savedPreferences.colour
        }

        // Set custom back button text to navigationItem
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Set the preferences that might have been changed by a child view
        self.preferences.colourNum = stateController?.convValues.colourNum ?? self.preferences.colourNum
        self.preferences.colour = stateController?.convValues.colour ?? self.preferences.colour
        self.preferences.copyActionIndex = stateController?.convValues.copyActionIndex ?? self.preferences.copyActionIndex
        self.preferences.pasteActionIndex = stateController?.convValues.pasteActionIndex ?? self.preferences.pasteActionIndex
        
        // Colour the navigation bar
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: self.preferences.colour]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: self.preferences.colour]
        navigationItem.backBarButtonItem?.tintColor = self.preferences.colour
        
        // Child might have preferred small titles
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.reloadData()
    }
    
    // Setup number of rows per section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowsPerSection[section]
    }
    
    // Setup number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTitles.count
    }
    
    // Setup section headers
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < self.sectionTitles.count {
            return sectionTitles[section]
        }

        return nil
    }
    
    // Build table cell layout
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        // Tab bar section
        case 0:
            // Hexadecimal
            if indexPath.row == 0 {
                // Show switch
                let cell = self.tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath) as! SwitchTableViewCell
                cell.configure(isOn: preferences.hexTabState, colour: self.preferences.colour)
                cell.textLabel?.text = "Hexadecimal"
                cell.self.cellSwitch.addTarget(self, action: #selector(self.hexadecimalSwitchPressed), for: .touchUpInside)
                return cell
            }
            // Binary
            else if indexPath.row == 1 {
                // Show switch
                let cell = self.tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath) as! SwitchTableViewCell
                cell.configure(isOn: preferences.binTabState, colour: self.preferences.colour)
                cell.textLabel?.text = "Binary"
                cell.self.cellSwitch.addTarget(self, action: #selector(self.binarySwitchPressed), for: .touchUpInside)
                return cell
            }
            // Decimal
            else {
                // Show switch
                let cell = self.tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath) as! SwitchTableViewCell
                cell.configure(isOn: preferences.decTabState, colour: self.preferences.colour)
                cell.textLabel?.text = "Decimal"
                cell.self.cellSwitch.addTarget(self, action: #selector(self.decimalSwitchPressed), for: .touchUpInside)
                return cell
            }
        // Gestures section
        case 1:
            // Copy action
            if indexPath.row == 0 {
                // Show summary detail view for copy action selection
                let cell = self.tableView.dequeueReusableCell(withIdentifier: SelectionSummaryTableViewCell.identifier, for: indexPath) as! SelectionSummaryTableViewCell
                cell.configure(rightText: CopyOrPasteActionConverter.getActionFromIndex(index: Int(self.preferences.copyActionIndex), paste: false), colour: UIColor.systemGray)
                cell.textLabel?.text = "Copy Action"
                return cell
            }
            // Paste action
            else {
                // Show summary detail view for paste action selection
                let cell = self.tableView.dequeueReusableCell(withIdentifier: SelectionSummaryTableViewCell.identifier, for: indexPath) as! SelectionSummaryTableViewCell
                cell.configure(rightText: CopyOrPasteActionConverter.getActionFromIndex(index: Int(self.preferences.pasteActionIndex), paste: true), colour: UIColor.systemGray)
                cell.textLabel?.text = "Paste Action"
                return cell
            }
        // Customization section
        case 2:
            // Set calculator text colour
            if indexPath.row == 1 {
                // Show switch for set calculator text colour
                let cell = self.tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath) as! SwitchTableViewCell
                cell.configure(isOn: self.preferences.setCalculatorTextColour, colour: preferences.colour)
                cell.textLabel?.text = "Set Calculator Text Colour"
                cell.self.cellSwitch.addTarget(self, action: #selector(self.setCalculatorTextColourSwitchPressed), for: .touchUpInside)
                return cell
            }
            // Select colour preference
            else {
                // Show summary detail view for colour selection
                let cell = self.tableView.dequeueReusableCell(withIdentifier: SelectionSummaryTableViewCell.identifier, for: indexPath) as! SelectionSummaryTableViewCell
                cell.configure(rightText: ColourNumberConverter.getColourNameFromIndex(index: Int(self.preferences.colourNum)), colour: UIColor.systemGray)
                cell.textLabel?.text = "Colour"
                return cell
            }
        // About the app section
        case 3:
            // App version
            if indexPath.row == 0 {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as! TextTableViewCell
                // Get the app version label
                let appVersionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
                cell.configure(rightText: appVersionNumber)
                cell.textLabel?.text = "App Version"
                return cell
            }
            // Open source link
            else if indexPath.row == 1 {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as! ImageTableViewCell
                cell.configure(image: "GitHub")
                cell.textLabel?.text = "HexaCalc is Open Source"
                return cell
            }
//            if indexPath.row == 0 {
//                // Show switch
//                let cell = self.tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath) as! SwitchTableViewCell
//                cell.configure(with: "Hexadecimal")
//                return cell
//            }
//            else {
                // Show text
                let cell = self.tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath)
                cell.textLabel?.text = "Test"
                return cell
            //}
        default:
            fatalError("Index out of range")
        }
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Navigate to copy or paste action selection view
        if indexPath.section == 1 {
            if let subjectCell = tableView.cellForRow(at: indexPath), let destinationViewController = navigationController?.storyboard?.instantiateViewController(withIdentifier: SettingsSelectionViewController.identifier) as? SettingsSelectionViewController {
                destinationViewController.selectionList = ["Single Tap", "Double Tap", "Off"]
                destinationViewController.preferences = self.preferences
                destinationViewController.selectedIndex = indexPath.row == 0 ? Int(preferences.copyActionIndex) : Int(preferences.pasteActionIndex)
                destinationViewController.selectionType = indexPath.row == 0 ? SelectionType.copyAction : SelectionType.pasteAction
                destinationViewController.stateController = stateController
                destinationViewController.name = indexPath.row == 0 ? "Copy Action" : "Paste Action"
                
                // Navigate to new view
                navigationController?.pushViewController(destinationViewController, animated: true)
            }
        }
        // Navigate to colour selection view
        if indexPath.section == 2 && indexPath.row == 0 {
            if let subjectCell = tableView.cellForRow(at: indexPath), let destinationViewController = navigationController?.storyboard?.instantiateViewController(withIdentifier: SettingsSelectionViewController.identifier) as? SettingsSelectionViewController {
                destinationViewController.selectionList = ["Red", "Orange", "Yellow", "Green", "Blue", "Teal", "Indigo", "Violet"]
                destinationViewController.preferences = self.preferences
                destinationViewController.selectedIndex = self.preferences.colourNum == -1 ? 3 : Int(self.preferences.colourNum)
                destinationViewController.selectionType = SelectionType.colour
                destinationViewController.stateController = stateController
                destinationViewController.name = "Colour"
                
                // Navigate to new view
                navigationController?.pushViewController(destinationViewController, animated: true)
            }
        }
        // Open a URL
        if indexPath.section == 3 && indexPath.row > 0 {
            let currentURL = NSURL(string: urls[indexPath.row - 1])! as URL
            UIApplication.shared.open(currentURL, options: [:], completionHandler: nil)
        }
                
    }
    
    @IBAction func hexadecimalSwitchPressed(_ sender: UISwitch) {
        let userPreferences = UserPreferences(colour: preferences.colour, colourNum: (stateController?.convValues.colourNum)!,
                                              hexTabState: sender.isOn, binTabState: preferences.binTabState, decTabState: preferences.decTabState,
                                              setCalculatorTextColour: preferences.setCalculatorTextColour,
                                              copyActionIndex: preferences.copyActionIndex, pasteActionIndex: preferences.pasteActionIndex)
        if sender.isOn {
            let arrayOfTabBarItems = tabBarController?.tabBar.items
            DataPersistence.savePreferences(userPreferences: userPreferences)

            if let barItems = arrayOfTabBarItems, barItems.count > 0 {
                if (barItems[0].title! != "Hexadecimal"){
                    var viewControllers = tabBarController?.viewControllers
                    viewControllers?.insert((stateController?.convValues.originalTabs?[0])!, at: 0)
                    tabBarController?.viewControllers = viewControllers
                }
            }
        }
        else {
            let arrayOfTabBarItems = tabBarController?.tabBar.items
            DataPersistence.savePreferences(userPreferences: userPreferences)

            if let barItems = arrayOfTabBarItems, barItems.count > 1 {
                if (barItems[0].title! == "Hexadecimal"){
                    var viewControllers = tabBarController?.viewControllers
                    viewControllers?.remove(at: 0)
                    tabBarController?.viewControllers = viewControllers
                }
            }
        }
        self.preferences = userPreferences
    }
    
    @IBAction func binarySwitchPressed(_ sender: UISwitch) {
        let userPreferences = UserPreferences(colour: preferences.colour, colourNum: (stateController?.convValues.colourNum)!,
                                              hexTabState: preferences.hexTabState, binTabState: sender.isOn, decTabState: preferences.decTabState,
                                              setCalculatorTextColour: preferences.setCalculatorTextColour,
                                              copyActionIndex: preferences.copyActionIndex, pasteActionIndex: preferences.pasteActionIndex)
        if sender.isOn {
            let arrayOfTabBarItems = tabBarController?.tabBar.items
            DataPersistence.savePreferences(userPreferences: userPreferences)

            if let barItems = arrayOfTabBarItems, barItems.count > 0 {
                switch barItems.count {
                case 1:
                    var viewControllers = tabBarController?.viewControllers
                    viewControllers?.insert((stateController?.convValues.originalTabs?[1])!, at: 0)
                    tabBarController?.viewControllers = viewControllers
                case 2:
                    if (barItems[0].title! == "Hexadecimal") {
                        var viewControllers = tabBarController?.viewControllers
                        viewControllers?.insert((stateController?.convValues.originalTabs?[1])!, at: 1)
                        tabBarController?.viewControllers = viewControllers
                    }
                    else if (barItems[0].title == "Binary") {
                        //Do nothing
                    }
                    else {
                        var viewControllers = tabBarController?.viewControllers
                        viewControllers?.insert((stateController?.convValues.originalTabs?[1])!, at: 0)
                        tabBarController?.viewControllers = viewControllers
                    }
                case 3:
                    var viewControllers = tabBarController?.viewControllers
                    viewControllers?.insert((stateController?.convValues.originalTabs?[1])!, at: 1)
                    tabBarController?.viewControllers = viewControllers
                default:
                    fatalError("Invalid number of tabs")
                }
            }
        }
        else {
            let arrayOfTabBarItems = tabBarController?.tabBar.items
            DataPersistence.savePreferences(userPreferences: userPreferences)

            if let barItems = arrayOfTabBarItems, barItems.count > 1 {
                if (barItems[0].title! == "Binary"){
                    var viewControllers = tabBarController?.viewControllers
                    viewControllers?.remove(at: 0)
                    tabBarController?.viewControllers = viewControllers
                }
                else if (barItems[1].title! == "Binary"){
                    var viewControllers = tabBarController?.viewControllers
                    viewControllers?.remove(at: 1)
                    tabBarController?.viewControllers = viewControllers
                }
                else {
                    //Do nothing
                }
            }
        }
        self.preferences = userPreferences
    }

    @IBAction func decimalSwitchPressed(_ sender: UISwitch) {
        let userPreferences = UserPreferences(colour: preferences.colour, colourNum: (stateController?.convValues.colourNum)!,
                                              hexTabState: preferences.hexTabState, binTabState: preferences.binTabState, decTabState: sender.isOn,
                                              setCalculatorTextColour: preferences.setCalculatorTextColour,
                                              copyActionIndex: preferences.copyActionIndex, pasteActionIndex: preferences.pasteActionIndex)
        if sender.isOn {
            let arrayOfTabBarItems = tabBarController?.tabBar.items
            DataPersistence.savePreferences(userPreferences: userPreferences)

            if let barItems = arrayOfTabBarItems, barItems.count > 0 {
                switch barItems.count {
                case 1:
                    var viewControllers = tabBarController?.viewControllers
                    viewControllers?.insert((stateController?.convValues.originalTabs?[2])!, at: 0)
                    tabBarController?.viewControllers = viewControllers
                case 2:
                    var viewControllers = tabBarController?.viewControllers
                    viewControllers?.insert((stateController?.convValues.originalTabs?[2])!, at: 1)
                    tabBarController?.viewControllers = viewControllers
                case 3:
                    var viewControllers = tabBarController?.viewControllers
                    viewControllers?.insert((stateController?.convValues.originalTabs?[2])!, at: 2)
                    tabBarController?.viewControllers = viewControllers
                default:
                    fatalError("Invalid number of tabs")
                }
            }
        }
        else {
            let arrayOfTabBarItems = tabBarController?.tabBar.items
            DataPersistence.savePreferences(userPreferences: userPreferences)

            if let barItems = arrayOfTabBarItems, barItems.count > 1 {
                if (barItems[0].title! == "Decimal"){
                    var viewControllers = tabBarController?.viewControllers
                    viewControllers?.remove(at: 0)
                    tabBarController?.viewControllers = viewControllers
                }
                else if (barItems[1].title! == "Decimal"){
                    var viewControllers = tabBarController?.viewControllers
                    viewControllers?.remove(at: 1)
                    tabBarController?.viewControllers = viewControllers
                }
                else if (barItems[2].title! == "Decimal"){
                    var viewControllers = tabBarController?.viewControllers
                    viewControllers?.remove(at: 2)
                    tabBarController?.viewControllers = viewControllers
                }
                else {
                    //Do nothing
                }
            }
        }
        self.preferences = userPreferences
    }
    
    // Function to toggle the optional setting of the calculator text colour
    @IBAction func setCalculatorTextColourSwitchPressed(_ sender: UISwitch) {
        let userPreferences = UserPreferences(colour: preferences.colour, colourNum: (stateController?.convValues.colourNum)!,
                                              hexTabState: preferences.hexTabState, binTabState: preferences.binTabState, decTabState: preferences.decTabState,
                                              setCalculatorTextColour: sender.isOn,
                                              copyActionIndex: preferences.copyActionIndex, pasteActionIndex: preferences.pasteActionIndex)
        DataPersistence.savePreferences(userPreferences: userPreferences)
        stateController?.convValues.setCalculatorTextColour = sender.isOn
        self.preferences = userPreferences
    }
    
//    @IBOutlet weak var optionsLabel: UILabel!
//    @IBOutlet weak var hexLabel: UILabel!
//    @IBOutlet weak var binLabel: UILabel!
//    @IBOutlet weak var decLabel: UILabel!
//    @IBOutlet weak var colourLabel: UILabel!
//    @IBOutlet weak var setCalculatorTextColourLabel: UILabel!
//    @IBOutlet weak var copyLabel: UILabel!
//    @IBOutlet weak var pasteLabel: UILabel!
//
//    @IBOutlet weak var hexSwitch: UISwitch!
//    @IBOutlet weak var binSwitch: UISwitch!
//    @IBOutlet weak var decSwitch: UISwitch!
//    @IBOutlet weak var setCalculatorTextColourSwitch: UISwitch!
//
//    @IBOutlet weak var redBtn: RoundButton!
//    @IBOutlet weak var orangeBtn: RoundButton!
//    @IBOutlet weak var yellowBtn: RoundButton!
//    @IBOutlet weak var greenBtn: RoundButton!
//    @IBOutlet weak var blueBtn: RoundButton!
//    @IBOutlet weak var tealBtn: RoundButton!
//    @IBOutlet weak var indigoBtn: RoundButton!
//    @IBOutlet weak var purpleBtn: RoundButton!
//
//
//    @IBOutlet weak var copyControl: UISegmentedControl!
//    @IBOutlet weak var pasteControl: UISegmentedControl!
//
//    @IBOutlet weak var colourButtonsStack: UIStackView!
//    @IBOutlet weak var copyStack: UIStackView!
//    @IBOutlet weak var pasteStack: UIStackView!
//
//    @IBOutlet weak var infoButton: UIBarButtonItem!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Remove border from navigationBar
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//
//        // Set custom back button text to navigationItem
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: nil, action: nil)
//
//        let labels = [hexLabel, optionsLabel, binLabel, decLabel, colourLabel, setCalculatorTextColourLabel, copyLabel, pasteLabel]
//        let switches = [hexSwitch, binSwitch, decSwitch, setCalculatorTextColourSwitch]
//        let buttons = [redBtn, orangeBtn, yellowBtn, greenBtn, blueBtn, tealBtn, indigoBtn, purpleBtn]
//
//        //Setup the button border widths
//        for button in buttons {
//            button!.layer.borderWidth = 3
//        }
//
//        copyControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
//        pasteControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
//
//        if let savedPreferences = DataPersistence.loadPreferences() {
//            for label in labels {
//                label?.textColor = savedPreferences.colour
//            }
//
//            for entry in switches {
//                entry!.onTintColor = savedPreferences.colour
//            }
//
//            copyControl.selectedSegmentTintColor = savedPreferences.colour
//            pasteControl.selectedSegmentTintColor = savedPreferences.colour
//            infoButton.tintColor = savedPreferences.colour
//            navigationItem.backBarButtonItem?.tintColor = savedPreferences.colour
//            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: savedPreferences.colour]
//            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: savedPreferences.colour]
//
//            if (savedPreferences.binTabState == false) {
//                binSwitch.isOn = false
//            }
//            if (savedPreferences.decTabState == false) {
//                decSwitch.isOn = false
//            }
//            if (savedPreferences.hexTabState == false) {
//                hexSwitch.isOn = false
//            }
//
//            if (savedPreferences.setCalculatorTextColour == true) {
//                setCalculatorTextColourSwitch.isOn = true
//            }
//            else {
//                setCalculatorTextColourSwitch.isOn = false
//            }
//
//            copyControl.selectedSegmentIndex = Int(savedPreferences.copyActionIndex)
//            pasteControl.selectedSegmentIndex = Int(savedPreferences.pasteActionIndex)
//
//            //Setup the correct button borders based on the selected colour
//            stateController?.convValues.colourNum = savedPreferences.colourNum
//
//            var highlightedIndex = 0
//            switch savedPreferences.colourNum {
//            //Default case if the colour was never changed but a tab was
//            case -1:
//                highlightedIndex = 3
//            //Red needs to be selected
//            case 0:
//                highlightedIndex = 0
//            //Orange needs to be selected
//            case 1:
//                highlightedIndex = 1
//            //Yellow needs to be seelcted
//            case 2:
//                highlightedIndex = 2
//            //Green needs to be selected
//            case 3:
//                highlightedIndex = 3
//            //Blue needs to be selected
//            case 4:
//                highlightedIndex = 4
//            //Teal needs to be selected
//            case 5:
//                highlightedIndex = 5
//            //Indigo needs to be selected
//            case 6:
//                highlightedIndex = 6
//            //Purple needs to be selected
//            case 7:
//                highlightedIndex = 7
//            default:
//                fatalError("Unexpected colour identifier...")
//            }
//
//            //Set the button border colours
//            buttons[highlightedIndex]!.layer.borderColor = UIColor.white.cgColor
//
//            for (index, button) in buttons.enumerated() {
//                if (index != highlightedIndex) {
//                    button!.layer.borderColor = UIColor.darkGray.cgColor
//                }
//            }
//        }
//        else {
//            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGreen]
//            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGreen]
//            infoButton.tintColor = .systemGreen
//            navigationItem.backBarButtonItem?.tintColor = .systemGreen
//
//            //Default colour is green so outline that button only
//            greenBtn.layer.borderColor = UIColor.white.cgColor
//
//            redBtn.layer.borderColor = UIColor.darkGray.cgColor
//            orangeBtn.layer.borderColor = UIColor.darkGray.cgColor
//            yellowBtn.layer.borderColor = UIColor.darkGray.cgColor
//            blueBtn.layer.borderColor = UIColor.darkGray.cgColor
//            tealBtn.layer.borderColor = UIColor.darkGray.cgColor
//            indigoBtn.layer.borderColor = UIColor.darkGray.cgColor
//            purpleBtn.layer.borderColor = UIColor.darkGray.cgColor
//
//            stateController?.convValues.colourNum = -1
//        }
//    }
//
//    override func viewDidLayoutSubviews() {
//        let screenWidth = view.bounds.width
//
//        //Specific case for the smallest screen sizes
//        if (screenWidth <= 320){
//            //Need to edit the font size for this screen width size
//            optionsLabel?.font = UIFont(name: "Avenir Next", size: 18)
//            hexLabel?.font = UIFont(name: "Avenir Next", size: 18)
//            binLabel?.font = UIFont(name: "Avenir Next", size: 18)
//            decLabel?.font = UIFont(name: "Avenir Next", size: 18)
//            colourLabel?.font = UIFont(name: "Avenir Next", size: 18)
//            setCalculatorTextColourLabel?.font = UIFont(name: "Avenir Next", size: 18)
//            copyLabel?.font = UIFont(name: "Avenir Next", size: 18)
//            pasteLabel?.font = UIFont(name: "Avenir Next", size: 18)
//
//            copyStack.spacing = -20
//            pasteStack.spacing = -20
//
//            if (UIDevice.current.userInterfaceIdiom != .pad) {
//                navigationController?.navigationBar.prefersLargeTitles = false
//
//            }
//        }
//    }
//
//    //MARK: Button Actions
//    @IBAction func colourPressed(_ sender: RoundButton) {
//        let colourClicked = sender.self.backgroundColor
//        let colourIdentifier = sender.tag
//        let colourTag = "\(colourIdentifier)"
//        let userPreferences = UserPreferences(colour: colourClicked!, colourNum: Int64(colourIdentifier),
//                                              hexTabState: hexSwitch.isOn, binTabState: binSwitch.isOn, decTabState: decSwitch.isOn,
//                                              setCalculatorTextColour: setCalculatorTextColourSwitch.isOn,
//                                              copyActionIndex: Int32(copyControl.selectedSegmentIndex), pasteActionIndex: Int32(pasteControl.selectedSegmentIndex))
//
//        let labels = [hexLabel, optionsLabel, binLabel, decLabel, colourLabel, setCalculatorTextColourLabel, copyLabel, pasteLabel]
//        let switches = [hexSwitch, binSwitch, decSwitch, setCalculatorTextColourSwitch]
//        let buttons = [redBtn, orangeBtn, yellowBtn, greenBtn, blueBtn, tealBtn, indigoBtn, purpleBtn]
//
//        //Change elements onscreen to new colour
//        for label in labels {
//            label?.textColor = colourClicked
//        }
//
//        for entry in switches {
//            entry!.onTintColor = colourClicked
//        }
//
//        copyControl.selectedSegmentTintColor = colourClicked
//        pasteControl.selectedSegmentTintColor = colourClicked
//        infoButton.tintColor = colourClicked
//        navigationItem.backBarButtonItem?.tintColor = colourClicked
//        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: colourClicked!]
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: colourClicked!]
//
//        setCalculatorTextColourSwitch.onTintColor = colourClicked
//
//        //Set tab bar icon colour to new colour
//        tabBarController?.tabBar.tintColor = colourClicked
//
//        //Set state controller such that all calculators know the new colour without a reload
//        stateController?.convValues.colour = colourClicked!
//        stateController?.convValues.colourNum = Int64(colourIdentifier)
//
//        var highlightedIndex = 0
//        //Change the app icon based on which colour was selected
//        if (colourTag == "0") {
//            changeIcon(to: "HexaCalcIconRed")
//            highlightedIndex = 0
//        }
//        else if (colourTag == "1") {
//            changeIcon(to: "HexaCalcIconOrange")
//            highlightedIndex = 1
//        }
//        else if (colourTag == "2"){
//            changeIcon(to: "HexaCalcIconYellow")
//            highlightedIndex = 2
//        }
//        else if (colourTag == "3"){
//            changeIcon(to: "HexaCalcIconGreen")
//            highlightedIndex = 3
//        }
//        else if (colourTag == "4"){
//            changeIcon(to: "HexaCalcIconBlue")
//            highlightedIndex = 4
//        }
//        else if (colourTag == "5"){
//            changeIcon(to: "HexaCalcIconTeal")
//            highlightedIndex = 5
//        }
//        else if (colourTag == "6"){
//            changeIcon(to: "HexaCalcIconIndigo")
//            highlightedIndex = 6
//        }
//        else {
//            changeIcon(to: "HexaCalcIconPurple")
//            highlightedIndex = 7
//        }
//
//        //Set the button border colours
//        buttons[highlightedIndex]!.layer.borderColor = UIColor.white.cgColor
//
//        for (index, button) in buttons.enumerated() {
//            if (index != highlightedIndex) {
//                button!.layer.borderColor = UIColor.darkGray.cgColor
//            }
//        }
//
//        DataPersistence.savePreferences(userPreferences: userPreferences)
//    }
//

//    //Function to toggle the optional setting of the calculator text colour
//    @IBAction func setCalculatorTextColourSwitchPressed(_ sender: UISwitch) {
//        let userPreferences = UserPreferences(colour: optionsLabel.textColor, colourNum: (stateController?.convValues.colourNum)!,
//                                              hexTabState: hexSwitch.isOn, binTabState: binSwitch.isOn, decTabState: decSwitch.isOn,
//                                              setCalculatorTextColour: setCalculatorTextColourSwitch.isOn,
//                                              copyActionIndex: Int32(copyControl.selectedSegmentIndex), pasteActionIndex: Int32(pasteControl.selectedSegmentIndex))
//        DataPersistence.savePreferences(userPreferences: userPreferences)
//        stateController?.convValues.setCalculatorTextColour = setCalculatorTextColourSwitch.isOn
//    }
//
//    //Function to toggle the action for which a user copies the calculator value
//    @IBAction func copyIndexChanged(_ sender: Any) {
//        let userPreferences = UserPreferences(colour: optionsLabel.textColor, colourNum: (stateController?.convValues.colourNum)!,
//                                              hexTabState: hexSwitch.isOn, binTabState: binSwitch.isOn, decTabState: decSwitch.isOn,
//                                              setCalculatorTextColour: setCalculatorTextColourSwitch.isOn,
//                                              copyActionIndex: Int32(copyControl.selectedSegmentIndex), pasteActionIndex: Int32(pasteControl.selectedSegmentIndex))
//        DataPersistence.savePreferences(userPreferences: userPreferences)
//        stateController?.convValues.copyActionIndex = Int32(copyControl.selectedSegmentIndex)
//    }
//
//    //Function to toggle the action for which a user pastes into the calculator
//    @IBAction func pasteIndexChanged(_ sender: Any) {
//        let userPreferences = UserPreferences(colour: optionsLabel.textColor, colourNum: (stateController?.convValues.colourNum)!,
//                                              hexTabState: hexSwitch.isOn, binTabState: binSwitch.isOn, decTabState: decSwitch.isOn,
//                                              setCalculatorTextColour: setCalculatorTextColourSwitch.isOn,
//                                              copyActionIndex: Int32(copyControl.selectedSegmentIndex), pasteActionIndex: Int32(pasteControl.selectedSegmentIndex))
//        DataPersistence.savePreferences(userPreferences: userPreferences)
//        stateController?.convValues.pasteActionIndex = Int32(pasteControl.selectedSegmentIndex)
//    }
//
//    //MARK: Private Functions
//
//    //Function to change the app icon to one of the preloaded options
//    func changeIcon(to iconName: String) {
//      //First, need to make sure the app can change its icon
//      guard UIApplication.shared.supportsAlternateIcons else {
//        return
//      }
//
//      //Next we can actually work on changing the app icon
//      UIApplication.shared.setAlternateIconName(iconName, completionHandler: { (error) in
//        //Output the result of the icon change
//        if let error = error {
//          print("App icon failed to change due to \(error.localizedDescription)")
//        } else {
//          print("App icon changed successfully")
//        }
//      })
//    }
}

//Adds state controller to the view controller
extension SettingsViewController: StateControllerProtocol {
  func setState(state: StateController) {
    self.stateController = state
  }
}
