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
        // UI tests must launch the application that they test.
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
        
        // App rating popup might appear
        if (app.scrollViews.otherElements.buttons["Not Now"].exists) {
            app.scrollViews.otherElements.buttons["Not Now"].tap()
        }
        
        tabBar.buttons["Hexadecimal"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "D6F", calculator: 0))
    }
    
    func testHexadecimalBasicCalculations() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let acButton = app.buttons["AC"]
        let divButton = app.buttons["÷"]
        let multButton = app.buttons["×"]
        let subButton = app.buttons["-"]
        let plusButton = app.buttons["+"]
        let equalsButton = app.buttons["="]
        
        app.buttons["1"].tap()
        app.buttons["0"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "10", calculator: 0))
        
        // Addition
        plusButton.tap()
        
        app.buttons["3"].tap()
        app.buttons["2"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "32", calculator: 0))
        
        equalsButton.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "42", calculator: 0))
        
        // Subtraction
        subButton.tap()
        
        app.buttons["3"].tap()
        app.buttons["0"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "30", calculator: 0))
        
        equalsButton.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "12", calculator: 0))
        
        // Multiplication
        multButton.tap()
        
        app.buttons["F"].tap()
        app.buttons["E"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "FE", calculator: 0))
        
        equalsButton.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "11DC", calculator: 0))
        
        // Division
        divButton.tap()
        
        app.buttons["A"].tap()
        app.buttons["B"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "AB", calculator: 0))
        
        equalsButton.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1A", calculator: 0))
        
        acButton.tap()
                
        XCTAssert(!app.staticTexts["1A"].exists)
    }
    
    func testBinaryBasicCalculations() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let tabBar = app.tabBars["Tab Bar"]
        
        tabBar.buttons["Binary"].tap()
        
        let acButton = app.buttons["AC"]
        let divButton = app.buttons["÷"]
        let multButton = app.buttons["×"]
        let subButton = app.buttons["-"]
        let plusButton = app.buttons["+"]
        let equalsButton = app.buttons["="]
        
        app.buttons["1"].tap()
        app.buttons["0"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "10", calculator: 1))
        
        // Addition
        plusButton.tap()
        
        app.buttons["1"].tap()
        app.buttons["0"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "10", calculator: 1))
        
        equalsButton.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "100", calculator: 1))
        
        // Subtraction
        subButton.tap()
        
        app.buttons["1"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1", calculator: 1))
        
        equalsButton.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "11", calculator: 1))
        
        // Multiplication
        multButton.tap()
        
        app.buttons["1"].tap()
        app.buttons["1"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "11", calculator: 1))
        
        equalsButton.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1001", calculator: 1))
        
        // Division
        divButton.tap()
        
        app.buttons["1"].tap()
        app.buttons["1"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "11", calculator: 1))
        
        equalsButton.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "11", calculator: 1))
        
        acButton.tap()
                
        XCTAssert(!app.buttons[UITestHelper.formatBinaryString(stringToConvert: "11")].exists)
    }
    
    func testDecimalBasicCalculations() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let tabBar = app.tabBars["Tab Bar"]
        
        tabBar.buttons["Decimal"].tap()
        
        let acButton = app.buttons["AC"]
        let divButton = app.buttons["÷"]
        let multButton = app.buttons["×"]
        let subButton = app.buttons["-"]
        let plusButton = app.buttons["+"]
        let equalsButton = app.buttons["="]
        
        app.buttons["1"].tap()
        app.buttons["0"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "10", calculator: 2))
        
        // Addition
        plusButton.tap()
        
        app.buttons["7"].tap()
        app.buttons["6"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "76", calculator: 2))
        
        equalsButton.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "86", calculator: 2))
        
        // Subtraction
        subButton.tap()
        
        app.buttons["9"].tap()
        
        equalsButton.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "77", calculator: 2))
        
        // Multiplication
        multButton.tap()
        
        app.buttons["5"].tap()
        app.buttons["6"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "56", calculator: 2))
        
        equalsButton.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "4312", calculator: 2))
        
        // Division
        divButton.tap()
        
        app.buttons["4"].tap()
        
        equalsButton.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1078", calculator: 2))
        
        acButton.tap()
                
        XCTAssert(!app.buttons["196"].exists)
    }
}
