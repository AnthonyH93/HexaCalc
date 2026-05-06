//
//  HistoryButtonViewConverter.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2023-06-24.
//  Copyright © 2023 Anthony Hopkins. All rights reserved.
//

import Foundation

// Utility class for converting between history button view options
class HistoryButtonViewConverter {
    static func getViewFromIndex(index: Int) -> String {
        switch index {
        case 0:
            return "Icon Image"
        case 1:
            return "Text Label"
        default:
            return "Icon Image"
        }
    }
}
