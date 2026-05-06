//
//  UserPreferences.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2020-08-15.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit
import os.log

class UserPreferences : NSObject, NSCoding, NSSecureCoding {
    
    // Required to conform to NSSecureCoding
    static var supportsSecureCoding: Bool {
        return true
    }
    
    
    //MARK: Initialization
    
    //Prepares and instance of a class for use
    init(colour: UIColor, colourNum: Int64, hexTabState: Bool, binTabState: Bool, decTabState: Bool, setCalculatorTextColour: Bool, copyActionIndex: Int32, pasteActionIndex: Int32,
         historyButtonViewIndex: Int32, defaultTabIndex: Int32, historyEnabled: Bool = true) {
        //Initialize stored properties.
        self.colour = colour
        self.colourNum = colourNum
        self.hexTabState = hexTabState
        self.binTabState = binTabState
        self.decTabState = decTabState
        self.setCalculatorTextColour = setCalculatorTextColour
        self.copyActionIndex = copyActionIndex
        self.pasteActionIndex = pasteActionIndex
        self.historyButtonViewIndex = historyButtonViewIndex
        self.defaultTabIndex = defaultTabIndex
        self.historyEnabled = historyEnabled
    }
    
    //MARK: Properties
    
    var colour: UIColor
    var colourNum: Int64
    var hexTabState: Bool
    var binTabState: Bool
    var decTabState: Bool
    var setCalculatorTextColour: Bool
    var copyActionIndex: Int32
    var pasteActionIndex: Int32
    var historyButtonViewIndex: Int32
    var defaultTabIndex: Int32
    var historyEnabled: Bool
    
    //MARK: Archiving Paths
    
    //Marked with static since they belong to the class instead of an instance of the class
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("userPreferences")
    
    //MARK: Types
    
    struct PropertyKey {
        static let colour = "colour"
        static let colourNum = "colourNum"
        static let hexTabState = "hexTabState"
        static let binTabState = "binTabState"
        static let decTabState = "decTabState"
        static let setCalculatorTextColour = "setCalculatorTextColour"
        static let copyActionIndex = "copyActionIndex"
        static let pasteActionIndex = "pasteActionIndex"
        static let historyButtonViewIndex = "historyButtonViewIndex"
        static let defaultTabIndex = "defaultTabIndex"
        static let historyEnabled = "historyEnabled"
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(colour, forKey: PropertyKey.colour)
        aCoder.encode(colourNum, forKey: PropertyKey.colourNum)
        aCoder.encode(hexTabState, forKey: PropertyKey.hexTabState)
        aCoder.encode(binTabState, forKey: PropertyKey.binTabState)
        aCoder.encode(decTabState, forKey: PropertyKey.decTabState)
        aCoder.encode(setCalculatorTextColour, forKey: PropertyKey.setCalculatorTextColour)
        aCoder.encode(copyActionIndex, forKey: PropertyKey.copyActionIndex)
        aCoder.encode(pasteActionIndex, forKey: PropertyKey.pasteActionIndex)
        aCoder.encode(historyButtonViewIndex, forKey: PropertyKey.historyButtonViewIndex)
        aCoder.encode(defaultTabIndex, forKey: PropertyKey.defaultTabIndex)
        aCoder.encode(historyEnabled, forKey: PropertyKey.historyEnabled)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let colour = aDecoder.decodeObject(of: UIColor.self, forKey: PropertyKey.colour)!
        
        let colourNum = aDecoder.decodeInt64(forKey: PropertyKey.colourNum)
        
        let hexTabState = aDecoder.decodeBool(forKey: PropertyKey.hexTabState)
        
        let binTabState = aDecoder.decodeBool(forKey: PropertyKey.binTabState)
        
        let decTabState = aDecoder.decodeBool(forKey: PropertyKey.decTabState)
        
        let setCalculatorTextColour = aDecoder.decodeBool(forKey: PropertyKey.setCalculatorTextColour)
        
        let copyActionIndex = aDecoder.decodeInt32(forKey: PropertyKey.copyActionIndex)
        
        let pasteActionIndex = aDecoder.decodeInt32(forKey: PropertyKey.pasteActionIndex)
        
        let historyButtonViewIndex = aDecoder.decodeInt32(forKey: PropertyKey.historyButtonViewIndex)
        
        let defaultTabIndex = aDecoder.decodeInt32(forKey: PropertyKey.defaultTabIndex)

        // Default true for users upgrading from a version before historyEnabled was added
        let historyEnabled: Bool
        if aDecoder.containsValue(forKey: PropertyKey.historyEnabled) {
            historyEnabled = aDecoder.decodeBool(forKey: PropertyKey.historyEnabled)
        } else {
            historyEnabled = true
        }

        //Must call designated initializer
        self.init(
            colour: colour,
            colourNum: colourNum,
            hexTabState: hexTabState,
            binTabState: binTabState,
            decTabState: decTabState,
            setCalculatorTextColour: setCalculatorTextColour,
            copyActionIndex: copyActionIndex,
            pasteActionIndex: pasteActionIndex,
            historyButtonViewIndex: historyButtonViewIndex,
            defaultTabIndex: defaultTabIndex,
            historyEnabled: historyEnabled
        )
    }
    
    static func getDefaultPreferences() -> UserPreferences {
        return UserPreferences(
            colour: .systemGreen,
            colourNum: 3,
            hexTabState: true,
            binTabState: true,
            decTabState: true,
            setCalculatorTextColour: true,
            copyActionIndex: 0,
            pasteActionIndex: 0,
            historyButtonViewIndex: 0,
            defaultTabIndex: 3
        )
    }
}

