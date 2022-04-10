//
//  SettingsSelectionViewController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2022-04-09.
//  Copyright © 2022 Anthony Hopkins. All rights reserved.
//

import UIKit
import os.log

class SettingsSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    static let identifier = "SettingsSelectionVC"
    
    var selectionList: [String]?
    var selectedIndex: Int?
    var preferences: UserPreferences?
    
    var numberOfRows = 0
    
    private let tableView: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
        
        table.register(SelectionTableViewCell.self, forCellReuseIdentifier: SelectionTableViewCell.identifier)
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check if prefereces are saved
        if let selectionList = selectionList {
            if let preferences = preferences {
                if let selectedIndex = selectedIndex {
                    // Setup UI and properties
                    numberOfRows = selectionList.count
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // Setup number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRows
    }
    
    // Build table cell layout
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Currently selected index
        if indexPath.row == selectedIndex ?? 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: SelectionTableViewCell.identifier, for: indexPath) as! SelectionTableViewCell
            cell.textLabel?.text = "Test1"
            cell.configure(isSelected: true)
            return cell
        }
        // Alternate choice
        else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: SelectionTableViewCell.identifier, for: indexPath) as! SelectionTableViewCell
            cell.textLabel?.text = "Test"
            cell.configure(isSelected: false)
            return cell
        }
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
//    @IBAction func hexadecimalSwitchPressed(_ sender: UISwitch) {
//        let userPreferences = UserPreferences(colour: preferences.colour, colourNum: (stateController?.convValues.colourNum)!,
//                                              hexTabState: sender.isOn, binTabState: preferences.binTabState, decTabState: preferences.decTabState,
//                                              setCalculatorTextColour: preferences.setCalculatorTextColour,
//                                              copyActionIndex: preferences.copyActionIndex, pasteActionIndex: preferences.pasteActionIndex)
//        if sender.isOn {
//            let arrayOfTabBarItems = tabBarController?.tabBar.items
//            DataPersistence.savePreferences(userPreferences: userPreferences)
//
//            if let barItems = arrayOfTabBarItems, barItems.count > 0 {
//                if (barItems[0].title! != "Hexadecimal"){
//                    var viewControllers = tabBarController?.viewControllers
//                    viewControllers?.insert((stateController?.convValues.originalTabs?[0])!, at: 0)
//                    tabBarController?.viewControllers = viewControllers
//                }
//            }
//        }
//        else {
//            let arrayOfTabBarItems = tabBarController?.tabBar.items
//            DataPersistence.savePreferences(userPreferences: userPreferences)
//
//            if let barItems = arrayOfTabBarItems, barItems.count > 1 {
//                if (barItems[0].title! == "Hexadecimal"){
//                    var viewControllers = tabBarController?.viewControllers
//                    viewControllers?.remove(at: 0)
//                    tabBarController?.viewControllers = viewControllers
//                }
//            }
//        }
//        self.preferences = userPreferences
//    }
}
