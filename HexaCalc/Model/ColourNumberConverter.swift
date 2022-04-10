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
        default:
                return -1
        }
    }
}
