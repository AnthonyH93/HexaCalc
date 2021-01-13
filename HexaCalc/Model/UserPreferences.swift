//
//  UserPreferences.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2020-08-15.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit
import os.log

class UserPreferences : NSObject, NSCoding {
    
    //MARK: Initialization
    
    //Prepares and instance of a class for use
    init(colour: UIColor, colourNum: Int64, binTabState: Bool, decTabState: Bool, setCalculatorTextColour: Bool) {
        //Initialize stored properties.
        self.colour = colour
        self.colourNum = colourNum
        self.binTabState = binTabState
        self.decTabState = decTabState
        self.setCalculatorTextColour = setCalculatorTextColour
    }
    
    //MARK: Properties
    
    var colour: UIColor
    var colourNum: Int64
    var binTabState: Bool
    var decTabState: Bool
    var setCalculatorTextColour: Bool
    
    //MARK: Archiving Paths
    
    //Marked with static since they belong to the class instead of an instance of the class
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("userPreferences")
    
    //MARK: Types
    
    struct PropertyKey {
        static let colour = "colour"
        static let colourNum = "colourNum"
        static let binTabState = "binTabState"
        static let decTabState = "decTabState"
        static let setCalculatorTextColour = "setCalculatorTextColour"
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(colour, forKey: PropertyKey.colour)
        aCoder.encode(colourNum, forKey: PropertyKey.colourNum)
        aCoder.encode(binTabState, forKey: PropertyKey.binTabState)
        aCoder.encode(decTabState, forKey: PropertyKey.decTabState)
        aCoder.encode(setCalculatorTextColour, forKey: PropertyKey.setCalculatorTextColour)
    }
    
    //convenience means it is a secondary initializer (must call designated initializer), the ? means it is failable
    required convenience init?(coder aDecoder: NSCoder) {
        
        let colour = aDecoder.decodeObject(forKey: PropertyKey.colour) as! UIColor
        
        let colourNum = aDecoder.decodeInt64(forKey: PropertyKey.colourNum)
        
        let binTabState = aDecoder.decodeBool(forKey: PropertyKey.binTabState)
        
        let decTabState = aDecoder.decodeBool(forKey: PropertyKey.decTabState)
        
        let setCalculatorTextColour = aDecoder.decodeBool(forKey: PropertyKey.setCalculatorTextColour)
        
        //Must call designated initializer
        self.init(colour: colour, colourNum: colourNum, binTabState: binTabState, decTabState: decTabState, setCalculatorTextColour: setCalculatorTextColour)
    }
}

