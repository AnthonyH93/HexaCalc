//
//  SettingsSelectionViewController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2022-04-09.
//  Copyright © 2022 Anthony Hopkins. All rights reserved.
//

import UIKit
import os.log

// Type of settings selection instantiation
enum SelectionType {
    case colour
    case copyAction
    case pasteAction
}

class SettingsSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    var stateController: StateController?
    
    static let identifier = "SettingsSelectionVC"
    
    var selectionList: [String]?
    var selectedIndex: Int?
    var preferences: UserPreferences?
    var selectionType: SelectionType?
    var name: String?
    
    var numberOfRows = 0
    
    let textColour = [UIColor.systemRed, UIColor.systemOrange, UIColor.systemYellow, UIColor.systemGreen, UIColor.systemBlue, UIColor.systemTeal, UIColor.systemIndigo, UIColor.systemPurple]
    
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
        
        if let selectionList = selectionList {
            if let name = name {
                numberOfRows = selectionList.count
                self.title = name
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
        guard let selectedList = selectionList, let selectedIndex = selectedIndex
        else {
            fatalError("Paramaters were not set")
        }
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: SelectionTableViewCell.identifier, for: indexPath) as! SelectionTableViewCell
        cell.textLabel?.text = selectedList[indexPath.row]
        
        if let selectionType = selectionType {
            if selectionType == .colour {
                cell.textLabel?.textColor = textColour[indexPath.row]
            }
        }
        
        // Currently selected index
        if indexPath.row == selectedIndex {
            cell.configure(isSelected: true, colour: stateController?.convValues.colour ?? .systemGreen)
        }
        // Alternate choice
        else {
            cell.configure(isSelected: false, colour: stateController?.convValues.colour ?? .systemGreen)
        }
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionChanged(index: indexPath.row)
    }
    
    func selectionChanged(index: Int) {
        var shouldSavePreferences = false
        if let preferences = preferences {
            var userPreferences = UserPreferences.getDefaultPreferences()
            switch selectionType {
            case .colour:
                // Ensure that a different selection was made
                if preferences.colourNum != index {
                    shouldSavePreferences = true
                    let colour = ColourNumberConverter.getColourFromIndex(index: index)
                    userPreferences = UserPreferences(colour: colour, colourNum: Int64(index),
                                                      hexTabState: preferences.hexTabState, binTabState: preferences.binTabState, decTabState: preferences.decTabState,
                                                      setCalculatorTextColour: preferences.setCalculatorTextColour,
                                                      copyActionIndex: preferences.copyActionIndex, pasteActionIndex: preferences.pasteActionIndex)
                    
                    // Set tab bar icon colour to new colour
                    tabBarController?.tabBar.tintColor = colour
                    
                    // Change icon to new colour
                    self.changeIcon(to: ColourNumberConverter.getAppIconNameFromIndex(index: index))
                    
                    // Set state controller such that all calculators know the new colour without a reload
                    stateController?.convValues.colour = colour
                    stateController?.convValues.colourNum = Int64(index)
                }
            case .copyAction:
                // Ensure that a different selection was made
                if preferences.copyActionIndex != index {
                    shouldSavePreferences = true
                    userPreferences = UserPreferences(colour: preferences.colour, colourNum: preferences.colourNum,
                                                      hexTabState: preferences.hexTabState, binTabState: preferences.binTabState, decTabState: preferences.decTabState,
                                                      setCalculatorTextColour: preferences.setCalculatorTextColour,
                                                      copyActionIndex: Int32(index), pasteActionIndex: preferences.pasteActionIndex)
                    stateController?.convValues.copyActionIndex = Int32(index)
                }
            case .pasteAction:
                // Ensure that a different selection was made
                if preferences.pasteActionIndex != index {
                    shouldSavePreferences = true
                    userPreferences = UserPreferences(colour: preferences.colour, colourNum: preferences.colourNum,
                                                      hexTabState: preferences.hexTabState, binTabState: preferences.binTabState, decTabState: preferences.decTabState,
                                                      setCalculatorTextColour: preferences.setCalculatorTextColour,
                                                      copyActionIndex: preferences.copyActionIndex, pasteActionIndex: Int32(index))
                    stateController?.convValues.pasteActionIndex = Int32(index)
                }
            default:
                fatalError("SelectionType is not defined")
            }
            
            // Only save and navigate away if there is a new selection
            if shouldSavePreferences {
                DataPersistence.savePreferences(userPreferences: userPreferences)
                
                // Navigate back to settings tab
                if let navController = self.navigationController {
                    navController.popViewController(animated: true)
                }
            }
        }
    }
    
    //MARK: Private Functions

    // Function to change the app icon to one of the preloaded options
    func changeIcon(to iconName: String) {
      // First, need to make sure the app can change its icon
      guard UIApplication.shared.supportsAlternateIcons else {
        return
      }

      // Next we can actually work on changing the app icon
      UIApplication.shared.setAlternateIconName(iconName, completionHandler: { (error) in
        // Output the result of the icon change
        if let error = error {
          print("App icon failed to change due to \(error.localizedDescription)")
        } else {
          print("App icon changed successfully")
        }
      })
    }
}
