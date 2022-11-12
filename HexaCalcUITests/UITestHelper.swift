//
//  UITestHelper.swift
//  HexaCalcUITests
//
//  Created by Anthony Hopkins on 2022-11-12.
//  Copyright © 2022 Anthony Hopkins. All rights reserved.
//

import XCTest
import UIKit

class UITestHelper {
    // Helper functions
    static func assertResult(app: XCUIApplication, expected: String, calculator: Int) -> Bool {
        // Hexadecimal
        if calculator == 0 {
            return app.staticTexts[expected].label == expected
        }
        // Binary
        else if calculator == 1 {
            let text = formatBinaryString(stringToConvert: expected)
            return app.buttons[text].label == text
        }
        // Decimal
        else {
            let text = formatDecimalString(stringToConvert: expected)
            return app.buttons[text].label == text
        }
    }
    
    static func formatBinaryString(stringToConvert: String) -> String {
        var manipulatedStringToConvert = stringToConvert
        while (manipulatedStringToConvert.count < 64){
            manipulatedStringToConvert = "0" + manipulatedStringToConvert
        }
        return manipulatedStringToConvert.separate(every: 4, with: " ")
    }
    
    static func formatDecimalString(stringToConvert: String) -> String {
        let manipulatedStringToConvert = String(stringToConvert.reversed())
        return String(manipulatedStringToConvert.separate(every: 3, with: ",").reversed())
    }
}
