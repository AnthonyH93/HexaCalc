//
//  CopyOrPasteActionConverter.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2022-04-11.
//  Copyright © 2022 Anthony Hopkins. All rights reserved.
//

import Foundation

// Utility class for converting between copy/paste actions and indexes
class CopyOrPasteActionConverter {
    static func getActionFromIndex(index: Int, paste: Bool) -> String {
        switch index {
        case 0:
            return "Single Tap"
        case 1:
            return "Double Tap"
        case 2:
            return "Off"
        default:
            return paste ? "Double Tap" : "Single Tap"
        }
    }
}
