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
            let outputLabel = app.staticTexts["Hexadecimal Output Label"]
            return expected == outputLabel.label
        }
        // Binary
        else if calculator == 1 {
            let outputLabel = app.buttons["Binary Output Label"]
            let text = formatBinaryString(stringToConvert: expected)
            return outputLabel.label == text
        }
        // Decimal
        else {
            let outputLabel = app.buttons["Decimal Output Label"]
            let text = formatDecimalString(stringToConvert: expected)
            return outputLabel.label == text
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
