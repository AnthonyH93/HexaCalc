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
    // Define button operation names
    static let delete = "DEL"
    static let clear = "AC"
    static let divide = "÷"
    static let multiply = "×"
    static let subtract = "-"
    static let add = "+"
    static let equals = "="
    static let xor = "XOR"
    static let or = "OR"
    static let and = "AND"
    static let not = "NOT"
    static let second = "2nd"
    static let ones = "1's"
    static let twos = "2's"
    static let mod = "MOD"
    static let exp = "xʸ"
    static let leftShift = "<<"
    static let rightShift = ">>"
    static let leftShiftX = "<<X"
    static let rightShiftX = ">>X"
    static let plusMinus = "±"
    static let sqrt = "√"
    
    // Button tap functions
    static func delete(app: XCUIApplication) {
        app.buttons[delete].tap()
    }
    
    static func clear(app: XCUIApplication) {
        app.buttons[clear].tap()
    }
    
    static func divide(app: XCUIApplication) {
        app.buttons[divide].tap()
    }
    
    static func multiply(app: XCUIApplication) {
        app.buttons[multiply].tap()
    }
    
    static func subtract(app: XCUIApplication) {
        app.buttons[subtract].tap()
    }
    
    static func add(app: XCUIApplication) {
        app.buttons[add].tap()
    }
    
    static func equals(app: XCUIApplication) {
        app.buttons[equals].tap()
    }
    
    static func xor(app: XCUIApplication) {
        app.buttons[xor].tap()
    }
    
    static func or(app: XCUIApplication) {
        app.buttons[or].tap()
    }
    
    static func and(app: XCUIApplication) {
        app.buttons[and].tap()
    }
    
    static func not(app: XCUIApplication) {
        app.buttons[not].tap()
    }
    
    static func second(app: XCUIApplication) {
        app.buttons[second].tap()
    }
    
    static func ones(app: XCUIApplication) {
        app.buttons[ones].tap()
    }
    
    static func twos(app: XCUIApplication) {
        app.buttons[twos].tap()
    }
    
    static func mod(app: XCUIApplication) {
        app.buttons[mod].tap()
    }
    
    static func exp(app: XCUIApplication) {
        app.buttons[exp].tap()
    }
    
    static func leftShift(app: XCUIApplication) {
        app.buttons[leftShift].tap()
    }
    
    static func rightShift(app: XCUIApplication) {
        app.buttons[rightShift].tap()
    }
    
    static func leftShiftX(app: XCUIApplication) {
        app.buttons[leftShiftX].tap()
    }
    
    static func rightShiftX(app: XCUIApplication) {
        app.buttons[rightShiftX].tap()
    }
    
    static func plusMinus(app: XCUIApplication) {
        app.buttons[plusMinus].tap()
    }
    
    static func sqrt(app: XCUIApplication) {
        app.buttons[sqrt].tap()
    }
    
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
    
    static func tapResult(app: XCUIApplication, calculator: Int) {
        // Hexadecimal
        if calculator == 0 {
            app.staticTexts["Hexadecimal Output Label"].tap()
        }
        // Binary
        else if calculator == 1 {
            app.buttons["Binary Output Label"].tap()
        }
        // Decimal
        else {
            app.buttons["Decimal Output Label"].tap()
        }
    }
    
    static func doubleTapResult(app: XCUIApplication, calculator: Int) {
        // Hexadecimal
        if calculator == 0 {
            app.staticTexts["Hexadecimal Output Label"].doubleTap()
        }
        // Binary
        else if calculator == 1 {
            app.buttons["Binary Output Label"].doubleTap()
        }
        // Decimal
        else {
            app.buttons["Decimal Output Label"].doubleTap()
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
