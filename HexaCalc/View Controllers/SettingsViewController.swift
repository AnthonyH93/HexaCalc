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
                          "Calculation History",
                          "About the app",
                          "Support" ]
    let rowsPerSection = [4, 2, 2, 2, 4, 3]
    
    let supportURLs = [ "https://anthony55hopkins.wixsite.com/hexacalc/privacy-policy",
                        "https://anthony55hopkins.wixsite.com/hexacalc/terms-conditions" ]
    let aboutAppURLs = [ "https://github.com/AnthonyH93/HexaCalc" ]
    
    let feedbackAddress = "hexacalc@gmail.com"
    
    var preferences = UserPreferences.getDefaultPreferences()
    
    // Access singleton TelemetryManager class object
    let telemetryManager = TelemetryManager.sharedTelemetryManager
    let telemetryTab = TelemetryTab.Settings
    
    private let tableView: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
        
        // We don't want cells to be reused since there are a finite number and reuse has problems when they are reloaded due to state changes
        table.register(TextTableViewCell.self, forCellReuseIdentifier: "AppVersion")
        table.register(TextTableViewCell.self, forCellReuseIdentifier: "ShareApp")
        table.register(TextTableViewCell.self, forCellReuseIdentifier: "WriteReview")
        table.register(TextTableViewCell.self, forCellReuseIdentifier: "PrivacyPolicy")
        table.register(TextTableViewCell.self, forCellReuseIdentifier: "TermsAndConditions")
        table.register(TextTableViewCell.self, forCellReuseIdentifier: "EmailFeedback")
        table.register(TextTableViewCell.self, forCellReuseIdentifier: "ClearHistory")
        table.register(SwitchTableViewCell.nib(), forCellReuseIdentifier: "SetCalculatorColourSwitch")
        table.register(SwitchTableViewCell.nib(), forCellReuseIdentifier: "HexadecimalSwitch")
        table.register(SwitchTableViewCell.nib(), forCellReuseIdentifier: "BinarySwitch")
        table.register(SwitchTableViewCell.nib(), forCellReuseIdentifier: "DecimalSwitch")
        table.register(SwitchTableViewCell.nib(), forCellReuseIdentifier: "HistorySwitch")
        table.register(SelectionSummaryTableViewCell.self, forCellReuseIdentifier: "ColourSelection")
        table.register(SelectionSummaryTableViewCell.self, forCellReuseIdentifier: "CopyActionSelection")
        table.register(SelectionSummaryTableViewCell.self, forCellReuseIdentifier: "PasteActionSelection")
        table.register(SelectionSummaryTableViewCell.self, forCellReuseIdentifier: "HistoryButtonSelection")
        table.register(SelectionSummaryTableViewCell.self, forCellReuseIdentifier: "DefaultTabSelection")
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
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // Launching settings is a review worthy action, request a review if appropriate
        ReviewManager.requestReviewIfAppropriate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        else if (self.preferences.historyButtonViewIndex != stateController?.convValues.historyButtonViewIndex) {
            self.preferences.historyButtonViewIndex = stateController?.convValues.historyButtonViewIndex ?? self.preferences.historyButtonViewIndex
            // Reload UI only when necessary
            self.tableView.reloadSections([3], with: .none)
        }
        else if (self.preferences.defaultTabIndex != stateController?.convValues.defaultTabIndex) {
            self.preferences.defaultTabIndex = stateController?.convValues.defaultTabIndex ?? self.preferences.defaultTabIndex
            // Reload UI only when necessary
            self.tableView.reloadSections([0], with: .none)
        }
        
        // Colour the navigation bar
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.backBarButtonItem?.tintColor = .white
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
            else if indexPath.row == 2 {
                // Show switch
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "DecimalSwitch", for: indexPath) as! SwitchTableViewCell
                cell.configure(isOn: preferences.decTabState, colour: self.preferences.colour)
                cell.textLabel?.text = "Decimal"
                cell.self.cellSwitch.addTarget(self, action: #selector(self.decimalSwitchPressed), for: .touchUpInside)
                return cell
            }
            // Default tab
            else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "DefaultTabSelection", for: indexPath) as! SelectionSummaryTableViewCell
                cell.configure(rightText: DefaultTabViewConverter.getViewFromIndex(index: Int(self.preferences.defaultTabIndex)), colour: UIColor.systemGray)
                cell.textLabel?.text = "Override Default Selected Tab"
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
        // Calculation history section
        case 3:
            // Select history button display preference
            if indexPath.row == 0 {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "HistoryButtonSelection", for: indexPath) as! SelectionSummaryTableViewCell
                cell.configure(rightText: HistoryButtonViewConverter.getViewFromIndex(index: Int(self.preferences.historyButtonViewIndex)), colour: UIColor.systemGray)
                cell.textLabel?.text = "History Button View"
                return cell
            }
            // Clear local history
            else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "ClearHistory", for: indexPath) as! TextTableViewCell
                cell.textLabel?.text = "Clear Local History"
                cell.textLabel?.textColor = preferences.colour
                return cell
            }
        // About the app section
        case 4:
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
        case 5:
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
        // Override default selected tab
        if indexPath.section == 0 && indexPath.row == 3 {
            // Navigate to Override default selected tab view
            if let _ = tableView.cellForRow(at: indexPath), let destinationViewController = navigationController?.storyboard?.instantiateViewController(withIdentifier: SettingsSelectionViewController.identifier) as? SettingsSelectionViewController {
                destinationViewController.selectionList = ["Hexadecimal", "Binary", "Decimal", "Off"]
                destinationViewController.preferences = self.preferences
                destinationViewController.selectedIndex = Int(self.preferences.defaultTabIndex)
                destinationViewController.selectionType = SelectionType.defaultTabIndex
                destinationViewController.stateController = stateController
                destinationViewController.name = "Default Selected Tab"
                
                // Navigate to new view
                navigationController?.pushViewController(destinationViewController, animated: true)
            }
            }
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
                destinationViewController.selectionList = ["Red", "Orange", "Yellow", "Green", "Blue", "Teal", "Indigo", "Violet", "Pink", "Brown"]
                destinationViewController.preferences = self.preferences
                destinationViewController.selectedIndex = self.preferences.colourNum == -1 ? 3 : Int(self.preferences.colourNum)
                destinationViewController.selectionType = SelectionType.colour
                destinationViewController.stateController = stateController
                destinationViewController.name = "Colour"
                
                // Navigate to new view
                navigationController?.pushViewController(destinationViewController, animated: true)
            }
        }
        // Calculation history operations
        if indexPath.section == 3 {
            // Navigate to history button selection view
            if indexPath.row == 0 {
                if let _ = tableView.cellForRow(at: indexPath), let destinationViewController = navigationController?.storyboard?.instantiateViewController(withIdentifier: SettingsSelectionViewController.identifier) as? SettingsSelectionViewController {
                    destinationViewController.selectionList = ["Icon Image", "Text Label", "Off"]
                    destinationViewController.preferences = self.preferences
                    destinationViewController.selectedIndex = Int(self.preferences.historyButtonViewIndex)
                    destinationViewController.selectionType = SelectionType.historyButtonView
                    destinationViewController.stateController = stateController
                    destinationViewController.name = "History Button View"
                    
                    // Navigate to new view
                    navigationController?.pushViewController(destinationViewController, animated: true)
                }
            }
            // Clear local history
            else {
                // Set the flag to 7 (111 in binary)
                stateController?.convValues.clearLocalHistory = 7
                
                // Tell the user that the history was cleared
                let alert = UIAlertController(title: "Local History Cleared", message: "The local calculation history for all calculators has been cleared.", preferredStyle: .alert)
                
                present(alert, animated: true) {
                    tableView.deselectRow(at: indexPath, animated: true)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    alert.dismiss(animated: true, completion: nil)
                }
                
                telemetryManager.sendSettingsSignal(
                    section: TelemetrySettingsSection.History,
                    action: TelemetrySettingsAction.ClearHistory
                )
            }
        }
        // Open an about the app URL or open share detail menu
        if indexPath.section == 4 && indexPath.row > 0 {
            if indexPath.row == 3 {
                if let currentURL = ReviewManager.getWriteReviewURL() {
                    telemetryManager.sendSettingsSignal(
                        section: TelemetrySettingsSection.About,
                        action: TelemetrySettingsAction.Review
                    )
                    UIApplication.shared.open(currentURL)
                }
            }
            // Present share the app activity view
            else if indexPath.row == 2 {
                let activityViewController = UIActivityViewController(activityItems: [ReviewManager.getProductURL()], applicationActivities: nil)
                // To prevent crashes on iPads
                activityViewController.popoverPresentationController?.sourceView = self.tableView.cellForRow(at: indexPath)
                present(activityViewController, animated: true, completion: nil)
                
                telemetryManager.sendSettingsSignal(
                    section: TelemetrySettingsSection.About,
                    action: TelemetrySettingsAction.Share
                )
            }
            // Open link to GitHub
            else {
                let currentURL = NSURL(string: aboutAppURLs[indexPath.row - 1])! as URL
                telemetryManager.sendSettingsSignal(
                    section: TelemetrySettingsSection.About,
                    action: TelemetrySettingsAction.OpenSource
                )
                UIApplication.shared.open(currentURL, options: [:], completionHandler: nil)
            }
        }
        // Open a support URL
        if indexPath.section == 5 {
            if indexPath.row < 2 {
                let currentURL = NSURL(string: supportURLs[indexPath.row])! as URL
                UIApplication.shared.open(currentURL, options: [:], completionHandler: nil)
            }
            else {
                telemetryManager.sendSettingsSignal(
                    section: TelemetrySettingsSection.Support,
                    action: TelemetrySettingsAction.Email
                )
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
                                              copyActionIndex: preferences.copyActionIndex, pasteActionIndex: preferences.pasteActionIndex,
                                              historyButtonViewIndex: preferences.historyButtonViewIndex, defaultTabIndex: preferences.defaultTabIndex)
        if sender.isOn {
            DataPersistence.savePreferences(userPreferences: userPreferences)
            tabBarController?.tabBar.items![0].isEnabled = true
        }
        else {
            DataPersistence.savePreferences(userPreferences: userPreferences)
            tabBarController?.tabBar.items![0].isEnabled = false
        }
        self.preferences = userPreferences
        
        telemetryManager.sendSettingsSignal(
            section: TelemetrySettingsSection.TabBar,
            action: TelemetrySettingsAction.Hexadecimal,
            parameters: [
                "switchState": "\(sender.isOn)"
            ]
        )
    }
    
    @IBAction func binarySwitchPressed(_ sender: UISwitch) {
        let userPreferences = UserPreferences(colour: preferences.colour, colourNum: (stateController?.convValues.colourNum)!,
                                              hexTabState: preferences.hexTabState, binTabState: sender.isOn, decTabState: preferences.decTabState,
                                              setCalculatorTextColour: preferences.setCalculatorTextColour,
                                              copyActionIndex: preferences.copyActionIndex, pasteActionIndex: preferences.pasteActionIndex,
                                              historyButtonViewIndex: preferences.historyButtonViewIndex, defaultTabIndex: preferences.defaultTabIndex)
        if sender.isOn {
            DataPersistence.savePreferences(userPreferences: userPreferences)
            tabBarController?.tabBar.items![1].isEnabled = true
        }
        else {
            DataPersistence.savePreferences(userPreferences: userPreferences)
            tabBarController?.tabBar.items![1].isEnabled = false
        }
        self.preferences = userPreferences
        
        telemetryManager.sendSettingsSignal(
            section: TelemetrySettingsSection.TabBar,
            action: TelemetrySettingsAction.Binary,
            parameters: [
                "switchState": "\(sender.isOn)"
            ]
        )
    }

    @IBAction func decimalSwitchPressed(_ sender: UISwitch) {
        let userPreferences = UserPreferences(colour: preferences.colour, colourNum: (stateController?.convValues.colourNum)!,
                                              hexTabState: preferences.hexTabState, binTabState: preferences.binTabState, decTabState: sender.isOn,
                                              setCalculatorTextColour: preferences.setCalculatorTextColour,
                                              copyActionIndex: preferences.copyActionIndex, pasteActionIndex: preferences.pasteActionIndex,
                                              historyButtonViewIndex: preferences.historyButtonViewIndex, defaultTabIndex: preferences.defaultTabIndex)
        if sender.isOn {
            DataPersistence.savePreferences(userPreferences: userPreferences)
            tabBarController?.tabBar.items![2].isEnabled = true
        }
        else {
            DataPersistence.savePreferences(userPreferences: userPreferences)
            tabBarController?.tabBar.items![2].isEnabled = false
        }
        self.preferences = userPreferences
        
        telemetryManager.sendSettingsSignal(
            section: TelemetrySettingsSection.TabBar,
            action: TelemetrySettingsAction.Decimal,
            parameters: [
                "switchState": "\(sender.isOn)"
            ]
        )
    }
    
    // Function to toggle the optional setting of the calculator text colour
    @IBAction func setCalculatorTextColourSwitchPressed(_ sender: UISwitch) {
        let userPreferences = UserPreferences(colour: preferences.colour, colourNum: (stateController?.convValues.colourNum)!,
                                              hexTabState: preferences.hexTabState, binTabState: preferences.binTabState, decTabState: preferences.decTabState,
                                              setCalculatorTextColour: sender.isOn,
                                              copyActionIndex: preferences.copyActionIndex, pasteActionIndex: preferences.pasteActionIndex,
                                              historyButtonViewIndex: preferences.historyButtonViewIndex, defaultTabIndex: preferences.defaultTabIndex)
        DataPersistence.savePreferences(userPreferences: userPreferences)
        stateController?.convValues.setCalculatorTextColour = sender.isOn
        self.preferences = userPreferences
        
        telemetryManager.sendSettingsSignal(
            section: TelemetrySettingsSection.Customization,
            action: TelemetrySettingsAction.TextColour,
            parameters: [
                "switchState": "\(sender.isOn)"
            ]
        )
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
