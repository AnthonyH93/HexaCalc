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
            var text = expected
            if stringHasNumbers(stringToCheck: expected) {
                text = formatBinaryString(stringToConvert: expected)
            }
            return outputLabel.label == text
        }
        // Decimal
        else {
            let outputLabel = app.buttons["Decimal Output Label"]
            var text = expected
            if (stringHasNumbers(stringToCheck: expected) && !(expected.contains("e"))) {
                text = formatDecimalString(stringToConvert: expected)
            }
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
        var isNegative = false
        var hasDecimal = false
        if (stringToConvert.hasPrefix("-")) {
            isNegative = true
        }
        if (stringToConvert.contains(".")) {
            hasDecimal = true
        }
        
        var preparedString = stringToConvert
        if (isNegative) {
            preparedString.remove(at: preparedString.startIndex)
        }
        var fractionalComponent = ""
        if (hasDecimal) {
            let splits = preparedString.split(separator: ".")
            preparedString = String(splits[0])
            fractionalComponent = String(splits[1])
        }
        
        let manipulatedStringToConvert = String(preparedString.reversed())
        var result = String(manipulatedStringToConvert.separate(every: 3, with: ",").reversed())
        if (isNegative) {
            result = "-" + result
        }
        if (hasDecimal) {
            result.append("." + fractionalComponent)
        }
        return result
    }
    
    static func stringHasNumbers(stringToCheck: String) -> Bool {
        let numbersRange = stringToCheck.rangeOfCharacter(from: .decimalDigits)
        return numbersRange != nil
    }
}
