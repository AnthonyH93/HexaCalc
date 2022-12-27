//
//  DecimalHexaCalcUITests.swift
//  HexaCalcUITests
//
//  Created by Anthony Hopkins on 2022-12-10.
//  Copyright © 2022 Anthony Hopkins. All rights reserved.
//

import XCTest
import UIKit

class DecimalHexaCalcUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Navigate to the decimal tab before running each test
        
        let app = XCUIApplication()
        app.launch()
        
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Decimal"].tap()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDeletion() throws {
        let app = XCUIApplication()
        
        app.buttons["1"].tap()
        for _ in 0..<5 {
            app.buttons["0"].tap()
        }
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "100000", calculator: 2))
        
        // Test delete button
        UITestHelper.delete(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "10000", calculator: 2))
        
        // Test delete gesture
        app.buttons["Decimal Output Label"].swipeLeft()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1000", calculator: 2))
        
        // Test delete after computation
        UITestHelper.add(app: app)
        app.buttons["1"].tap()
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1001", calculator: 2))
        
        UITestHelper.delete(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1001", calculator: 2))
        
        // Test deleting entire string
        UITestHelper.clear(app: app)
        app.buttons["1"].tap()
        app.buttons["0"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "10", calculator: 2))
        
        UITestHelper.delete(app: app)
        UITestHelper.delete(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 2))
    }
    
    func testIntegerOverflow() throws {
        let app = XCUIApplication()
        
        app.buttons["1"].tap()
        for _ in 0..<8 {
            app.buttons["9"].tap()
        }
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "199999999", calculator: 2))
        
        UITestHelper.multiply(app: app)
        
        app.buttons["1"].tap()
        for _ in 0..<8 {
            app.buttons["9"].tap()
        }
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "199999999", calculator: 2))
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "4e16", calculator: 2))
        
        UITestHelper.multiply(app: app)
        
        app.buttons["1"].tap()
        for _ in 0..<8 {
            app.buttons["9"].tap()
        }
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "8e24", calculator: 2))
        
        // Ensure other calculators have integer overflow
        let tabBar = app.tabBars["Tab Bar"]
        
        tabBar.buttons["Binary"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "Error! Integer Overflow!", calculator: 1))
        
        tabBar.buttons["Hexadecimal"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "Error! Integer Overflow!", calculator: 0))
        
        tabBar.buttons["Decimal"].tap()
        
        UITestHelper.multiply(app: app)
        
        app.buttons["9"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "7.2e25", calculator: 2))
        
        // Clear the integer overflow
        UITestHelper.clear(app: app)
        
        tabBar.buttons["Binary"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 1))
        
        tabBar.buttons["Hexadecimal"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 0))
    }
    
    func testAllNumberButtons() throws {
        let app = XCUIApplication()
        
        let digits = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
        
        for digit in digits {
            app.buttons[digit].tap()
        }
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: digits.joined(), calculator: 2))
    }
    
    func testDecimalPointOperations() throws {
        let app = XCUIApplication()
        
        app.buttons["1"].tap()
        
        UITestHelper.divide(app: app)
        
        app.buttons["3"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0.33333333", calculator: 2))
        
        UITestHelper.multiply(app: app)
        
        app.buttons["2"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0.66666667", calculator: 2))
        
        UITestHelper.add(app: app)
        
        app.buttons["1"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1.66666667", calculator: 2))
        
        UITestHelper.subtract(app: app)
        
        app.buttons["5"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "-3.33333333", calculator: 2))
        
        UITestHelper.second(app: app)
        
        UITestHelper.plusMinus(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "3.33333333", calculator: 2))
    }
    
    func testScientificNotation() throws {
        let app = XCUIApplication()
        
        app.buttons["8"].tap()
        for _ in 0..<8 {
            app.buttons["9"].tap()
        }
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "899999999", calculator: 2))
        
        UITestHelper.multiply(app: app)
        
        app.buttons["8"].tap()
        for _ in 0..<8 {
            app.buttons["9"].tap()
        }
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "8.1e17", calculator: 2))
        
        UITestHelper.divide(app: app)
        
        app.buttons["6"].tap()
        app.buttons["5"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1.24615e16", calculator: 2))
        
        UITestHelper.divide(app: app)
        
        app.buttons["8"].tap()
        for _ in 0..<8 {
            app.buttons["9"].tap()
        }
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "899999999", calculator: 2))
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "13846153.8", calculator: 2))
    }
    
    func testPlusMinus() throws {
        let app = XCUIApplication()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 2))
        
        UITestHelper.second(app: app)
        UITestHelper.plusMinus(app: app)
        UITestHelper.second(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 2))
        
        app.buttons["1"].tap()
        
        UITestHelper.second(app: app)
        UITestHelper.plusMinus(app: app)
        UITestHelper.second(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "-1", calculator: 2))
        
        UITestHelper.multiply(app: app)
        
        app.buttons["8"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "-8", calculator: 2))
        
        UITestHelper.second(app: app)
        UITestHelper.plusMinus(app: app)
        UITestHelper.second(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "8", calculator: 2))
        
        UITestHelper.multiply(app: app)
        
        app.buttons["9"].tap()
        
        UITestHelper.second(app: app)
        UITestHelper.plusMinus(app: app)
        UITestHelper.second(app: app)
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "-72", calculator: 2))
        
        UITestHelper.multiply(app: app)
        
        app.buttons["9"].tap()
        
        UITestHelper.second(app: app)
        UITestHelper.plusMinus(app: app)
        UITestHelper.second(app: app)
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "648", calculator: 2))
        
        UITestHelper.second(app: app)
        UITestHelper.plusMinus(app: app)
        UITestHelper.second(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "-648", calculator: 2))
        
        UITestHelper.clear(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 2))
        
        // Test deleting a negative number
        
        app.buttons["9"].tap()
        app.buttons["8"].tap()
        
        UITestHelper.second(app: app)
        UITestHelper.plusMinus(app: app)
        UITestHelper.second(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "-98", calculator: 2))
        
        UITestHelper.delete(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "-9", calculator: 2))
        
        UITestHelper.delete(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 2))
    }
    
    func testMOD() throws {
        let app = XCUIApplication()

        UITestHelper.second(app: app)
        
        app.buttons["1"].tap()
        
        UITestHelper.mod(app: app)
        
        app.buttons["0"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "Error!", calculator: 2))
        
        UITestHelper.clear(app: app)
        
        app.buttons["5"].tap()
        
        UITestHelper.mod(app: app)
        
        app.buttons["9"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "5", calculator: 2))
        
        UITestHelper.clear(app: app)
        
        app.buttons["9"].tap()
        
        UITestHelper.mod(app: app)
        
        app.buttons["5"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "4", calculator: 2))
        
        UITestHelper.mod(app: app)
        
        app.buttons["2"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 2))
        
        UITestHelper.mod(app: app)
        
        app.buttons["8"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 2))
        
        UITestHelper.clear(app: app)
        
        app.buttons["5"].tap()
        
        UITestHelper.mod(app: app)
        
        app.buttons["7"].tap()
        UITestHelper.plusMinus(app: app)
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "5", calculator: 2))
        
        UITestHelper.mod(app: app)
        
        app.buttons["3"].tap()
        UITestHelper.plusMinus(app: app)
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "2", calculator: 2))
    }
    
    func testEXP() throws {
        let app = XCUIApplication()
        
        UITestHelper.second(app: app)
        
        app.buttons["1"].tap()
        
        UITestHelper.exp(app: app)
        
        app.buttons["0"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1", calculator: 2))
        
        UITestHelper.clear(app: app)
        
        app.buttons["5"].tap()
        
        UITestHelper.exp(app: app)
        
        app.buttons["1"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "5", calculator: 2))
        
        UITestHelper.exp(app: app)
        
        app.buttons["2"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "25", calculator: 2))
        
        UITestHelper.exp(app: app)
        
        app.buttons["8"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1.52588e11", calculator: 2))
        
        UITestHelper.exp(app: app)
        
        app.buttons["5"].tap()
        UITestHelper.plusMinus(app: app)
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1.20893e-56", calculator: 2))
        
        UITestHelper.clear(app: app)
        
        app.buttons["5"].tap()
        
        UITestHelper.exp(app: app)
        
        app.buttons["3"].tap()
        UITestHelper.plusMinus(app: app)
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0.008", calculator: 2))
        
        UITestHelper.clear(app: app)
        
        app.buttons["5"].tap()
        UITestHelper.plusMinus(app: app)
        
        UITestHelper.exp(app: app)
        
        app.buttons["3"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "-125", calculator: 2))
        
        UITestHelper.clear(app: app)
        
        app.buttons["1"].tap()
        app.buttons["."].tap()
        app.buttons["5"].tap()
        
        UITestHelper.exp(app: app)
        
        app.buttons["2"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "2.25", calculator: 2))
        
        UITestHelper.exp(app: app)
        
        app.buttons["1"].tap()
        app.buttons["."].tap()
        app.buttons["5"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "3.375", calculator: 2))
    }
    
    func testSQRT() throws {
        let app = XCUIApplication()
        
        UITestHelper.second(app: app)
        
        app.buttons["1"].tap()
        
        UITestHelper.sqrt(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1", calculator: 2))
        
        UITestHelper.clear(app: app)
        
        app.buttons["4"].tap()
        
        UITestHelper.sqrt(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "2", calculator: 2))
        
        UITestHelper.sqrt(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1.41421356", calculator: 2))
        
        UITestHelper.clear(app: app)
        
        UITestHelper.sqrt(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 2))
        
        UITestHelper.clear(app: app)
        
        app.buttons["5"].tap()
        UITestHelper.plusMinus(app: app)
        
        UITestHelper.sqrt(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "Error!", calculator: 2))
        
        UITestHelper.clear(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 2))
    }
}
