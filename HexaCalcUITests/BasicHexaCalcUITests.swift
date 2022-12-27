//
//  BasicHexaCalcUITests.swift
//  BasicHexaCalcUITests
//
//  Created by Anthony Hopkins on 2022-09-24.
//  Copyright © 2022 Anthony Hopkins. All rights reserved.
//

import XCTest
import UIKit

class BasicHexaCalcUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBasicAppSetup() throws {
        let app = XCUIApplication()
        app.launch()

        // Launched on Hexadecimal tab
        
        app.buttons["A"].tap()
        app.buttons["B"].tap()
                
        XCTAssert(UITestHelper.assertResult(app: app, expected: "AB", calculator: 0))
        
        let tabBar = app.tabBars["Tab Bar"]
        
        tabBar.buttons["Binary"].tap()
                
        XCTAssert(UITestHelper.assertResult(app: app, expected: "10101011", calculator: 1))
        
        app.staticTexts["1"].tap()
        
        tabBar.buttons["Decimal"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "343", calculator: 2))
        
        app.buttons["9"].tap()
        
        tabBar.buttons["Settings"].tap()
        
        tabBar.buttons["Hexadecimal"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "D6F", calculator: 0))
    }
    
    func testHexadecimalBasicCalculations() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["1"].tap()
        app.buttons["0"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "10", calculator: 0))
        
        // Addition
        UITestHelper.add(app: app)
        
        app.buttons["3"].tap()
        app.buttons["2"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "32", calculator: 0))
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "42", calculator: 0))
        
        // Subtraction
        UITestHelper.subtract(app: app)
        
        app.buttons["3"].tap()
        app.buttons["0"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "30", calculator: 0))
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "12", calculator: 0))
        
        // Multiplication
        UITestHelper.multiply(app: app)
        
        app.buttons["F"].tap()
        app.buttons["E"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "FE", calculator: 0))
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "11DC", calculator: 0))
        
        // Division
        UITestHelper.divide(app: app)
        
        app.buttons["A"].tap()
        app.buttons["B"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "AB", calculator: 0))
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1A", calculator: 0))
        
        UITestHelper.clear(app: app)
                
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 0))
    }
    
    func testBinaryBasicCalculations() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tabBar = app.tabBars["Tab Bar"]
        
        tabBar.buttons["Binary"].tap()
        
        app.buttons["1"].tap()
        app.buttons["0"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "10", calculator: 1))
        
        // Addition
        UITestHelper.add(app: app)
        
        app.buttons["1"].tap()
        app.buttons["0"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "10", calculator: 1))
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "100", calculator: 1))
        
        // Subtraction
        UITestHelper.subtract(app: app)
        
        app.buttons["1"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1", calculator: 1))
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "11", calculator: 1))
        
        // Multiplication
        UITestHelper.multiply(app: app)
        
        app.buttons["1"].tap()
        app.buttons["1"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "11", calculator: 1))
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1001", calculator: 1))
        
        // Division
        UITestHelper.divide(app: app)
        
        app.buttons["1"].tap()
        app.buttons["1"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "11", calculator: 1))
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "11", calculator: 1))
        
        UITestHelper.clear(app: app)
                
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 1))
    }
    
    func testDecimalBasicCalculations() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tabBar = app.tabBars["Tab Bar"]
        
        tabBar.buttons["Decimal"].tap()
        
        app.buttons["1"].tap()
        app.buttons["0"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "10", calculator: 2))
        
        // Addition
        UITestHelper.add(app: app)
        
        app.buttons["7"].tap()
        app.buttons["6"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "76", calculator: 2))
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "86", calculator: 2))
        
        // Subtraction
        UITestHelper.subtract(app: app)
        
        app.buttons["9"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "77", calculator: 2))
        
        // Multiplication
        UITestHelper.multiply(app: app)
        
        app.buttons["5"].tap()
        app.buttons["6"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "56", calculator: 2))
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "4312", calculator: 2))
        
        // Division
        UITestHelper.divide(app: app)
        
        app.buttons["4"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1078", calculator: 2))
        
        UITestHelper.clear(app: app)
                
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 2))
    }
    
    func testCopyPaste() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tabBar = app.tabBars["Tab Bar"]
        
        // Hexadecimal
        app.buttons["7"].tap()
        
        UITestHelper.add(app: app)
        
        app.buttons["8"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "F", calculator: 0))
        
        UITestHelper.tapResult(app: app, calculator: 0)
        
        // Sleep to wait for alert to disappear
        sleep(2)
        
        UITestHelper.clear(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 0))
        
        UITestHelper.doubleTapResult(app: app, calculator: 0)
        
        app.alerts["Paste from Clipboard"].scrollViews.otherElements.buttons["Confirm"].tap()
        if (app.alerts["“HexaCalc” would like to paste from “HexaCalc”"].scrollViews.otherElements.buttons["Allow Paste"].exists) {
            app.alerts["“HexaCalc” would like to paste from “HexaCalc”"].scrollViews.otherElements.buttons["Allow Paste"].tap()
        }
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "F", calculator: 0))
        
        // Binary
        tabBar.buttons["Binary"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1111", calculator: 1))
        
        UITestHelper.tapResult(app: app, calculator: 1)
        
        // Sleep to wait for alert to disappear
        sleep(2)
        
        UITestHelper.clear(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 1))
        
        UITestHelper.doubleTapResult(app: app, calculator: 1)
        
        app.alerts["Paste from Clipboard"].scrollViews.otherElements.buttons["Confirm"].tap()
        if (app.alerts["“HexaCalc” would like to paste from “HexaCalc”"].scrollViews.otherElements.buttons["Allow Paste"].exists) {
            app.alerts["“HexaCalc” would like to paste from “HexaCalc”"].scrollViews.otherElements.buttons["Allow Paste"].tap()
        }
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1111", calculator: 1))
        
        // Decimal
        tabBar.buttons["Decimal"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "15", calculator: 2))
        
        UITestHelper.tapResult(app: app, calculator: 2)
        
        // Sleep to wait for alert to disappear
        sleep(2)
        
        UITestHelper.clear(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 2))
        
        UITestHelper.doubleTapResult(app: app, calculator: 2)
        
        app.alerts["Paste from Clipboard"].scrollViews.otherElements.buttons["Confirm"].tap()
        if (app.alerts["“HexaCalc” would like to paste from “HexaCalc”"].scrollViews.otherElements.buttons["Allow Paste"].exists) {
            app.alerts["“HexaCalc” would like to paste from “HexaCalc”"].scrollViews.otherElements.buttons["Allow Paste"].tap()
        }
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "15", calculator: 2))
    }
}
