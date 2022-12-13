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
        app.buttons[UITestHelper.delete].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "10000", calculator: 2))
        
        // Test delete gesture
        app.buttons["Decimal Output Label"].swipeLeft()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1000", calculator: 2))
        
        // Test delete after computation
        app.buttons[UITestHelper.add].tap()
        app.buttons["1"].tap()
        app.buttons[UITestHelper.equals].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1001", calculator: 2))
        
        app.buttons[UITestHelper.delete].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1001", calculator: 2))
        
        // Test deleting entire string
        app.buttons[UITestHelper.clear].tap()
        app.buttons["1"].tap()
        app.buttons["0"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "10", calculator: 2))
        
        app.buttons[UITestHelper.delete].tap()
        app.buttons[UITestHelper.delete].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 2))
    }
    
    func testIntegerOverflow() throws {
        let app = XCUIApplication()
        
        let multButton = app.buttons[UITestHelper.multiply]
        let equalsButton = app.buttons[UITestHelper.equals]
        
        app.buttons["1"].tap()
        for _ in 0..<8 {
            app.buttons["9"].tap()
        }
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "199999999", calculator: 2))
        
        multButton.tap()
        
        app.buttons["1"].tap()
        for _ in 0..<8 {
            app.buttons["9"].tap()
        }
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "199999999", calculator: 2))
        
        equalsButton.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "4e16", calculator: 2))
        
        multButton.tap()
        
        app.buttons["1"].tap()
        for _ in 0..<8 {
            app.buttons["9"].tap()
        }
        
        equalsButton.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "8e24", calculator: 2))
        
        // Ensure other calculators have integer overflow
        let tabBar = app.tabBars["Tab Bar"]
        
        tabBar.buttons["Binary"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "Error! Integer Overflow!", calculator: 1))
        
        tabBar.buttons["Hexadecimal"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "Error! Integer Overflow!", calculator: 0))
        
        tabBar.buttons["Decimal"].tap()
        
        multButton.tap()
        
        app.buttons["9"].tap()
        
        equalsButton.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "7.2e25", calculator: 2))
        
        // Clear the integer overflow
        app.buttons[UITestHelper.clear].tap()
        
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
        
        let divButton = app.buttons[UITestHelper.divide]
        let multButton = app.buttons[UITestHelper.multiply]
        let subButton = app.buttons[UITestHelper.subtract]
        let plusButton = app.buttons[UITestHelper.add]
        let equalsButton = app.buttons[UITestHelper.equals]
        
        app.buttons["1"].tap()
        
        divButton.tap()
        
        app.buttons["3"].tap()
        
        equalsButton.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0.33333333", calculator: 2))
        
        multButton.tap()
        
        app.buttons["2"].tap()
        
        equalsButton.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0.66666667", calculator: 2))
        
        plusButton.tap()
        
        app.buttons["1"].tap()
        
        equalsButton.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1.66666667", calculator: 2))
        
        subButton.tap()
        
        app.buttons["5"].tap()
        
        equalsButton.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "-3.33333333", calculator: 2))
        
        app.buttons["2nd"].tap()
        
        app.buttons["±"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "3.33333333", calculator: 2))
    }
    
    func testScientificNotation() throws {
        let app = XCUIApplication()
        
        let divButton = app.buttons[UITestHelper.divide]
        let multButton = app.buttons[UITestHelper.multiply]
        let equalsButton = app.buttons[UITestHelper.equals]
        
        app.buttons["8"].tap()
        for _ in 0..<8 {
            app.buttons["9"].tap()
        }
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "899999999", calculator: 2))
        
        multButton.tap()
        
        app.buttons["8"].tap()
        for _ in 0..<8 {
            app.buttons["9"].tap()
        }
        
        equalsButton.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "8.1e17", calculator: 2))
        
        divButton.tap()
        
        app.buttons["6"].tap()
        app.buttons["5"].tap()
        
        equalsButton.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1.24615e16", calculator: 2))
        
        divButton.tap()
        
        app.buttons["8"].tap()
        for _ in 0..<8 {
            app.buttons["9"].tap()
        }
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "899999999", calculator: 2))
        
        equalsButton.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "13846153.8", calculator: 2))
    }
    
    func testPlusMinus() throws {
        let app = XCUIApplication()
        
        let secondFunc = app.buttons["2nd"]
        let plusMinus = app.buttons["±"]
        let multButton = app.buttons[UITestHelper.multiply]
        let equalsButton = app.buttons[UITestHelper.equals]
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 2))
        
        secondFunc.tap()
        plusMinus.tap()
        secondFunc.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 2))
        
        app.buttons["1"].tap()
        
        secondFunc.tap()
        plusMinus.tap()
        secondFunc.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "-1", calculator: 2))
        
        multButton.tap()
        
        app.buttons["8"].tap()
        
        equalsButton.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "-8", calculator: 2))
        
        secondFunc.tap()
        plusMinus.tap()
        secondFunc.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "8", calculator: 2))
        
        multButton.tap()
        
        app.buttons["9"].tap()
        
        secondFunc.tap()
        plusMinus.tap()
        secondFunc.tap()
        
        equalsButton.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "-72", calculator: 2))
        
        multButton.tap()
        
        app.buttons["9"].tap()
        
        secondFunc.tap()
        plusMinus.tap()
        secondFunc.tap()
        
        equalsButton.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "648", calculator: 2))
        
        secondFunc.tap()
        plusMinus.tap()
        secondFunc.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "-648", calculator: 2))
        
        app.buttons[UITestHelper.clear].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 2))
        
        // Test deleting a negative number
        
        app.buttons["9"].tap()
        app.buttons["8"].tap()
        
        secondFunc.tap()
        plusMinus.tap()
        secondFunc.tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "-98", calculator: 2))
        
        app.buttons[UITestHelper.delete].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "-9", calculator: 2))
        
        app.buttons[UITestHelper.delete].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 2))
    }
    
    func testMOD() throws {
        let app = XCUIApplication()
        
        let secondFunc = app.buttons["2nd"]
        let modFunc = app.buttons["MOD"]
        
        secondFunc.tap()
        
        app.buttons["1"].tap()
        
        modFunc.tap()
        
        app.buttons["0"].tap()
        
        app.buttons[UITestHelper.equals].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "Error!", calculator: 2))
        
        app.buttons[UITestHelper.clear].tap()
        
        app.buttons["5"].tap()
        
        modFunc.tap()
        
        app.buttons["9"].tap()
        
        app.buttons[UITestHelper.equals].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "5", calculator: 2))
        
        app.buttons[UITestHelper.clear].tap()
        
        app.buttons["9"].tap()
        
        modFunc.tap()
        
        app.buttons["5"].tap()
        
        app.buttons[UITestHelper.equals].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "4", calculator: 2))
        
        modFunc.tap()
        
        app.buttons["2"].tap()
        
        app.buttons[UITestHelper.equals].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 2))
        
        modFunc.tap()
        
        app.buttons["8"].tap()
        
        app.buttons[UITestHelper.equals].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 2))
        
        app.buttons[UITestHelper.clear].tap()
        
        app.buttons["5"].tap()
        
        modFunc.tap()
        
        app.buttons["7"].tap()
        app.buttons["±"].tap()
        
        app.buttons[UITestHelper.equals].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "5", calculator: 2))
        
        modFunc.tap()
        
        app.buttons["3"].tap()
        app.buttons["±"].tap()
        
        app.buttons[UITestHelper.equals].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "2", calculator: 2))
    }
    
    func testEXP() throws {
        let app = XCUIApplication()
        
        let secondFunc = app.buttons["2nd"]
        let expFunc = app.buttons["EXP"]
        
        secondFunc.tap()
        
        app.buttons["1"].tap()
        
        expFunc.tap()
        
        app.buttons["0"].tap()
        
        app.buttons[UITestHelper.equals].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1", calculator: 2))
        
        app.buttons[UITestHelper.clear].tap()
        
        app.buttons["5"].tap()
        
        expFunc.tap()
        
        app.buttons["1"].tap()
        
        app.buttons[UITestHelper.equals].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "5", calculator: 2))
        
        expFunc.tap()
        
        app.buttons["2"].tap()
        
        app.buttons[UITestHelper.equals].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "25", calculator: 2))
        
        expFunc.tap()
        
        app.buttons["8"].tap()
        
        app.buttons[UITestHelper.equals].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1.52588e11", calculator: 2))
        
        expFunc.tap()
        
        app.buttons["5"].tap()
        app.buttons["±"].tap()
        
        app.buttons[UITestHelper.equals].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1.20893e-56", calculator: 2))
        
        app.buttons[UITestHelper.clear].tap()
        
        app.buttons["5"].tap()
        
        expFunc.tap()
        
        app.buttons["3"].tap()
        app.buttons["±"].tap()
        
        app.buttons[UITestHelper.equals].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0.008", calculator: 2))
        
        app.buttons[UITestHelper.clear].tap()
        
        app.buttons["5"].tap()
        app.buttons["±"].tap()
        
        expFunc.tap()
        
        app.buttons["3"].tap()
        
        app.buttons[UITestHelper.equals].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "-125", calculator: 2))
    }
    
    func testSQRT() throws {
        
    }
}
