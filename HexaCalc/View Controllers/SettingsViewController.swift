//
//  SettingsViewController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2020-08-13.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit
import os.log
import MessageUI

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {

    //MARK: Properties
    var stateController: StateController?
    
    let sectionTitles = [ "Tab Bar",
                          "Gestures",
                          "Customization",
                          "About the app",
                          "Support" ]
    let rowsPerSection = [3, 2, 2, 4, 3]
    
    var actions = ["One tap", "Two tap"]
    
    let supportURLs = [ "https://anthony55hopkins.wixsite.com/hexacalc/privacy-policy",
                        "https://anthony55hopkins.wixsite.com/hexacalc/terms-conditions" ]
    let aboutAppURLs = [ "https://github.com/AnthonyH93/HexaCalc" ]
    
    let feedbackAddress = "hexacalc@gmail.com"
    
    var preferences = UserPreferences.getDefaultPreferences()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
        
        // We don't want cells to be reused since there are a finite number and reuse has problems when they are reloaded due to state changes
        table.register(TextTableViewCell.self, forCellReuseIdentifier: "AppVersion")
        table.register(TextTableViewCell.self, forCellReuseIdentifier: "ShareApp")
        table.register(TextTableViewCell.self, forCellReuseIdentifier: "WriteReview")
        table.register(TextTableViewCell.self, forCellReuseIdentifier: "PrivacyPolicy")
        table.register(TextTableViewCell.self, forCellReuseIdentifier: "TermsAndConditions")
        table.register(TextTableViewCell.self, forCellReuseIdentifier: "EmailFeedback")
        table.register(SwitchTableViewCell.nib(), forCellReuseIdentifier: "SetCalculatorColourSwitch")
        table.register(SwitchTableViewCell.nib(), forCellReuseIdentifier: "HexadecimalSwitch")
        table.register(SwitchTableViewCell.nib(), forCellReuseIdentifier: "BinarySwitch")
        table.register(SwitchTableViewCell.nib(), forCellReuseIdentifier: "DecimalSwitch")
        table.register(SelectionSummaryTableViewCell.self, forCellReuseIdentifier: "ColourSelection")
        table.register(SelectionSummaryTableViewCell.self, forCellReuseIdentifier: "CopyActionSelection")
        table.register(SelectionSummaryTableViewCell.self, forCellReuseIdentifier: "PasteActionSelection")
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
        else {
            // Use state controller as it will contain the default preferences
            self.preferences.copyActionIndex = self.stateController?.convValues.copyActionIndex ?? 0
            self.preferences.pasteActionIndex = self.stateController?.convValues.pasteActionIndex ?? 1
            self.preferences.setCalculatorTextColour = self.stateController?.convValues.setCalculatorTextColour ?? false
            self.preferences.colour = self.stateController?.convValues.colour ?? .systemGreen
        }

        // Set custom back button text to navigationItem
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        // Launching settings is a review worthy action, request a review if appropriate
        ReviewManager.requestReviewIfAppropriate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Set the preferences that might have been changed by a child view
        if (self.preferences.colourNum != stateController?.convValues.colourNum) {
            self.preferences.colourNum = stateController?.convValues.colourNum ?? self.preferences.colourNum
            self.preferences.colour = stateController?.convValues.colour ?? self.preferences.colour
            
            // Reload UI only when necessary
            self.tableView.reloadSections([0,2,3,4], with: .none)
        }
        else if (self.preferences.copyActionIndex != stateController?.convValues.copyActionIndex) {
            self.preferences.copyActionIndex = stateController?.convValues.copyActionIndex ?? self.preferences.copyActionIndex
            // Reload UI only when necessary
            self.tableView.reloadSections([1], with: .none)
        }
        else if (self.preferences.pasteActionIndex != stateController?.convValues.pasteActionIndex) {
            self.preferences.pasteActionIndex = stateController?.convValues.pasteActionIndex ?? self.preferences.pasteActionIndex
            // Reload UI only when necessary
            self.tableView.reloadSections([1], with: .none)
        }
        
        // Colour the navigation bar
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: self.preferences.colour]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: self.preferences.colour]
        navigationItem.backBarButtonItem?.tintColor = self.preferences.colour
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
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "HexadecimalSwitch", for: indexPath) as! SwitchTableViewCell
                cell.configure(isOn: preferences.hexTabState, colour: self.preferences.colour)
                cell.textLabel?.text = "Hexadecimal"
                cell.self.cellSwitch.addTarget(self, action: #selector(self.hexadecimalSwitchPressed), for: .touchUpInside)
                return cell
            }
            // Binary
            else if indexPath.row == 1 {
                // Show switch
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "BinarySwitch", for: indexPath) as! SwitchTableViewCell
                cell.configure(isOn: preferences.binTabState, colour: self.preferences.colour)
                cell.textLabel?.text = "Binary"
                cell.self.cellSwitch.addTarget(self, action: #selector(self.binarySwitchPressed), for: .touchUpInside)
                return cell
            }
            // Decimal
            else {
                // Show switch
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "DecimalSwitch", for: indexPath) as! SwitchTableViewCell
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
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "CopyActionSelection", for: indexPath) as! SelectionSummaryTableViewCell
                cell.configure(rightText: CopyOrPasteActionConverter.getActionFromIndex(index: Int(self.preferences.copyActionIndex), paste: false), colour: UIColor.systemGray)
                cell.textLabel?.text = "Copy Action"
                return cell
            }
            // Paste action
            else {
                // Show summary detail view for paste action selection
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "PasteActionSelection", for: indexPath) as! SelectionSummaryTableViewCell
                cell.configure(rightText: CopyOrPasteActionConverter.getActionFromIndex(index: Int(self.preferences.pasteActionIndex), paste: true), colour: UIColor.systemGray)
                cell.textLabel?.text = "Paste Action"
                return cell
            }
        // Customization section
        case 2:
            // Set calculator text colour
            if indexPath.row == 1 {
                // Show switch for set calculator text colour
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "SetCalculatorColourSwitch", for: indexPath) as! SwitchTableViewCell
                cell.configure(isOn: self.preferences.setCalculatorTextColour, colour: preferences.colour)
                cell.textLabel?.text = "Set Calculator Text Colour"
                cell.self.cellSwitch.addTarget(self, action: #selector(self.setCalculatorTextColourSwitchPressed), for: .touchUpInside)
                return cell
            }
            // Select colour preference
            else {
                // Show summary detail view for colour selection
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "ColourSelection", for: indexPath) as! SelectionSummaryTableViewCell
                cell.configure(rightText: ColourNumberConverter.getColourNameFromIndex(index: Int(self.preferences.colourNum)), colour: UIColor.systemGray)
                cell.textLabel?.text = "Colour"
                return cell
            }
        // About the app section
        case 3:
            // App version
            if indexPath.row == 0 {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "AppVersion", for: indexPath) as! TextTableViewCell
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
            // Share the app
            else if indexPath.row == 2 {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "ShareApp", for: indexPath)
                cell.textLabel?.text = "Share"
                cell.textLabel?.textColor = preferences.colour
                return cell
            }
            // Write a review
            else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "WriteReview", for: indexPath)
                cell.textLabel?.text = "Review HexaCalc"
                cell.textLabel?.textColor = preferences.colour
                return cell
            }
        // Support section
        case 4:
            if indexPath.row < 2 {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: indexPath.row == 0 ? "PrivacyPolicy" : "TermsAndConditions", for: indexPath)
                cell.textLabel?.text = indexPath.row == 0 ? "View Privacy Policy" : "View Terms and Conditions"
                cell.textLabel?.textColor = preferences.colour
                return cell
            }
            else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "EmailFeedback", for: indexPath)
                cell.textLabel?.text = "Email Feedback"
                cell.textLabel?.textColor = preferences.colour
                return cell
            }
        default:
            fatalError("Index out of range")
        }
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Navigate to copy or paste action selection view
        if indexPath.section == 1 {
            if let _ = tableView.cellForRow(at: indexPath), let destinationViewController = navigationController?.storyboard?.instantiateViewController(withIdentifier: SettingsSelectionViewController.identifier) as? SettingsSelectionViewController {
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
            if let _ = tableView.cellForRow(at: indexPath), let destinationViewController = navigationController?.storyboard?.instantiateViewController(withIdentifier: SettingsSelectionViewController.identifier) as? SettingsSelectionViewController {
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
        // Open an about the app URL or open share detail menu
        if indexPath.section == 3 && indexPath.row > 0 {
            if indexPath.row == 3 {
                if let currentURL = ReviewManager.getWriteReviewURL() {
                    UIApplication.shared.open(currentURL)
                }
            }
            // Present share the app activity view
            else if indexPath.row == 2 {
                let activityViewController = UIActivityViewController(activityItems: [ReviewManager.getProductURL()], applicationActivities: nil)
                // To prevent crashes on iPads
                activityViewController.popoverPresentationController?.sourceView = self.tableView.cellForRow(at: indexPath)
                present(activityViewController, animated: true, completion: nil)
            }
            // Open link to GitHub
            else {
                let currentURL = NSURL(string: aboutAppURLs[indexPath.row - 1])! as URL
                UIApplication.shared.open(currentURL, options: [:], completionHandler: nil)
            }
        }
        // Open a support URL
        if indexPath.section == 4 {
            if indexPath.row < 2 {
                let currentURL = NSURL(string: supportURLs[indexPath.row])! as URL
                UIApplication.shared.open(currentURL, options: [:], completionHandler: nil)
            }
            else {
                self.promptForEmail()
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
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
    
    //MARK: Private functions
    
    // Prompt user to send feedback email
    func promptForEmail() {
        if MFMailComposeViewController.canSendMail() {
            // Show alert to choose between report a bug or request a feature
            let alertMessage = "Please choose the best reason for sending feedback."
            let alert = UIAlertController(title: "Purpose of Feedback", message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Report a Problem", style: .default, handler: {_ in self.createEmail(problem: true)}))
            alert.addAction(UIAlertAction(title: "Request a Feature", style: .default, handler: {_ in self.createEmail(problem: false)}))
            
            self.present(alert, animated: true)
        }
        else {
            // Show failure alert
            let alertMessage = "Could not generate an email, please ensure that your Mail account is setup or manually send the email to \(self.feedbackAddress)."
            let alert = UIAlertController(title: "Email Generation Failed", message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    // Add app version and iOS version to
    func createEmail(problem: Bool) {
        let subject = problem ? "HexaCalc Report a Problem" : "HexaCalc Request a Feature"
        
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients([self.feedbackAddress])
        mail.setSubject(subject)
        
        // Add app version and iOS version
        if problem {
            let body = """
                        Meta Data
                        App Version: \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)
                        iOS Version: \(UIDevice.current.systemVersion)
                        """
            mail.setMessageBody(body, isHTML: false)
        }

        self.present(mail, animated: true)
    }
}

//Adds state controller to the view controller
extension SettingsViewController: StateControllerProtocol {
  func setState(state: StateController) {
    self.stateController = state
  }
}
