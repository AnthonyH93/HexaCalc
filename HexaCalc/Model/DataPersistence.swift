//
//  DataPersistence.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2020-09-10.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import Foundation
import os.log

//Struct for all data persistence loads and saves to resuse code in multiple view controllers
struct DataPersistence {
    
    //Save the user preferences
    static func savePreferences(userPreferences: UserPreferences) {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fullPath = paths[0].appendingPathComponent("userPreferences")
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: userPreferences, requiringSecureCoding: false)
            try data.write(to: fullPath)
            os_log("Preferences successfully saved.", log: OSLog.default, type: .debug)
        } catch {
            os_log("Failed to save preferences...", log: OSLog.default, type: .error)
        }
    }
    
    //Save method to load user preferences from the device if any are saved
    static func loadPreferences() -> UserPreferences? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fullPath = paths[0].appendingPathComponent("userPreferences")
        
        if let nsData = NSData(contentsOf: fullPath) {
            do {
                
                let data = Data(referencing:nsData)
                
                if let loadedPreferences = try NSKeyedUnarchiver.unarchivedObject(ofClass: UserPreferences.self, from: data) {
                    return loadedPreferences
                }
            } catch {
                print("Couldn't read file. Error: \(error)")
                return nil
            }
        }
        return nil
    }

    // The Hex/Binary word size lives in UserDefaults rather than UserPreferences: the
    // Settings screens rebuild UserPreferences from a copy loaded once in viewDidLoad,
    // so a value changed from a calculator tab would be silently overwritten by the
    // next Settings change.
    private static let wordSizeKey = "WordSizeBits"

    static func loadWordSize() -> WordSize {
        let stored = UserDefaults.standard.integer(forKey: wordSizeKey)
        return WordSize(rawValue: stored) ?? WordSize.defaultSize
    }

    static func saveWordSize(_ wordSize: WordSize) {
        UserDefaults.standard.set(wordSize.bits, forKey: wordSizeKey)
    }
}
