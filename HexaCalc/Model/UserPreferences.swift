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
    init(colour: UIColor, hexTabState: Bool, binTabState: Bool, decTabState: Bool) {
        //Initialize stored properties.
        self.colour = colour
        self.hexTabState = hexTabState
        self.binTabState = binTabState
        self.decTabState = decTabState
    }
    
    //MARK: Properties
    
    var colour: UIColor
    var hexTabState: Bool
    var binTabState: Bool
    var decTabState: Bool
    
    //MARK: Archiving Paths
    
    //Marked with static since they belong to the class instead of an instance of the class
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("userPreferences")
    
    //MARK: Types
    
    struct PropertyKey {
        static let colour = "colour"
        static let hexTabState = "hexTabState"
        static let binTabState = "binTabState"
        static let decTabState = "decTabState"
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(colour, forKey: PropertyKey.colour)
        aCoder.encode(hexTabState, forKey: PropertyKey.hexTabState)
        aCoder.encode(binTabState, forKey: PropertyKey.binTabState)
        aCoder.encode(decTabState, forKey: PropertyKey.decTabState)
    }
    
    //convenience means it is a secondary initializer (must call designated initializer), the ? means it is failable
    required convenience init?(coder aDecoder: NSCoder) {
        
        let colour = aDecoder.decodeObject(forKey: PropertyKey.colour) as! UIColor
        
        let hexTabState = aDecoder.decodeBool(forKey: PropertyKey.hexTabState)
        
        let binTabState = aDecoder.decodeBool(forKey: PropertyKey.binTabState)
        
        let decTabState = aDecoder.decodeBool(forKey: PropertyKey.decTabState)
        
        //Must call designated initializer.
        self.init(colour: colour, hexTabState: hexTabState, binTabState: binTabState, decTabState: decTabState)
    }
}
