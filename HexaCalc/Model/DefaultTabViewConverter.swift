//
//  DefaultTabViewConverter.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2025-02-24.
//  Copyright © 2025 Anthony Hopkins. All rights reserved.
//

import Foundation

// Utility class for converting between default tab options
class DefaultTabViewConverter {
    static func getViewFromIndex(index: Int) -> String {
        switch index {
        case 0:
            return "Hexadecimal"
        case 1:
            return "Binary"
        case 2:
            return "Decimal"
        case 3:
            return "Off"
        default:
            return "Off"
        }
    }
}
