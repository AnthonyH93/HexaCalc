//
//  ColourNumberConverter.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2022-04-10.
//  Copyright © 2022 Anthony Hopkins. All rights reserved.
//

import Foundation
import UIKit

// Utility class for converting between colours and indexes
class ColourNumberConverter {
    static func getColourFromIndex(index: Int) -> UIColor {
        switch index {
        case 0:
            return UIColor.systemRed
        case 1:
            return UIColor.systemOrange
        case 2:
            return UIColor.systemYellow
        case 3:
            return UIColor.systemGreen
        case 4:
            return UIColor.systemBlue
        case 5:
            return UIColor.systemTeal
        case 6:
            return UIColor.systemIndigo
        case 7:
            return UIColor.systemPurple
        case 8:
            return UIColor.systemPink
        case 9:
            return UIColor.systemBrown
        default:
            return UIColor.systemGreen
        }
    }
    
    static func getIndexFromColour(colour: UIColor) -> Int {
        switch colour {
        case .systemRed:
            return 0
        case .systemOrange:
            return 1
        case .systemYellow:
            return 2
        case .systemGreen:
            return 3
        case .systemBlue:
            return 4
        case .systemTeal:
            return 5
        case .systemIndigo:
            return 6
        case .systemPurple:
            return 7
        case .systemPink:
            return 8
        case .systemBrown:
            return 9
        default:
                return -1
        }
    }
    
    static func getAppIconNameFromIndex(index: Int) -> String {
        switch index {
        case 0:
            return "HexaCalcIconRed"
        case 1:
            return "HexaCalcIconOrange"
        case 2:
            return "HexaCalcIconYellow"
        case 3:
            return "HexaCalcIconGreen"
        case 4:
            return "HexaCalcIconBlue"
        case 5:
            return "HexaCalcIconTeal"
        case 6:
            return "HexaCalcIconIndigo"
        case 7:
            return "HexaCalcIconViolet"
        case 8:
            return "HexaCalcIconPink"
        case 9:
            return "HexaCalcIconBrown"
        default:
            return "HexaCalcIconGreen"
        }
    }
    
    static func getColourNameFromIndex(index: Int) -> String {
        switch index {
        case 0:
            return "Red"
        case 1:
            return "Orange"
        case 2:
            return "Yellow"
        case 3:
            return "Green"
        case 4:
            return "Blue"
        case 5:
            return "Teal"
        case 6:
            return "Indigo"
        case 7:
            return "Violet"
        case 8:
            return "Pink"
        case 9:
            return "Brown"
        default:
            return "Green"
        }
    }
}
