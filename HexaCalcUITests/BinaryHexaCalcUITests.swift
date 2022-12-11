//
//  BinaryHexaCalcUITests.swift
//  HexaCalcUITests
//
//  Created by Anthony Hopkins on 2022-12-09.
//  Copyright © 2022 Anthony Hopkins. All rights reserved.
//

import XCTest
import UIKit

class BinaryHexaCalcUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Navigate to the binary tab before running each test
        
        let app = XCUIApplication()
        app.launch()
        
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Binary"].tap()
        
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
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "100000", calculator: 1))
        
        // Test delete button
        app.buttons["DEL"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "10000", calculator: 1))
        
        // Test delete gesture
        app.buttons["Binary Output Label"].swipeLeft()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1000", calculator: 1))
        
        // Test delete after computation
        app.buttons["+"].tap()
        app.buttons["1"].tap()
        app.buttons["="].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1001", calculator: 1))
        
        app.buttons["DEL"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1001", calculator: 1))
        
        // Test deleting entire string
        app.buttons["AC"].tap()
        app.buttons["1"].tap()
        app.buttons["1"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "11", calculator: 1))
        
        app.buttons["DEL"].tap()
        app.buttons["DEL"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 1))
    }
    
    func testIntegerOverflow() throws {
        let app = XCUIApplication()
        
        var expectedString = "1"
        app.buttons["1"].tap()
        for _ in 0..<31 {
            app.buttons["11"].tap()
            expectedString.append("11")
        }
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: expectedString, calculator: 1))
        
        app.buttons["×"].tap()
        app.buttons["11"].tap()
        app.buttons["="].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "Error! Integer Overflow!", calculator: 1))
        
        app.buttons["AC"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 1))
    }
    
    func testAllNumberButtons() throws {
        let app = XCUIApplication()
        
        let digits = ["1", "0", "11", "00"]
        
        for digit in digits {
            app.buttons[digit].tap()
        }
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: digits.joined(), calculator: 1))
    }
    
    func testOperations() throws {
        let app = XCUIApplication()
        
        app.buttons["11"].tap()
        app.buttons["00"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1100", calculator: 1))
        
        // XOR
        app.buttons["XOR"].tap()
        
        app.buttons["11"].tap()
        app.buttons["00"].tap()
        app.buttons["0"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "11000", calculator: 1))
        
        app.buttons["="].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "10100", calculator: 1))
        
        // OR
        app.buttons["OR"].tap()
        
        app.buttons["11"].tap()
        app.buttons["00"].tap()
        app.buttons["1"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "11001", calculator: 1))
        
        app.buttons["="].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "11101", calculator: 1))
        
        // AND
        app.buttons["AND"].tap()
        
        app.buttons["11"].tap()
        app.buttons["1"].tap()
        app.buttons["0"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1110", calculator: 1))
        
        app.buttons["="].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1100", calculator: 1))
        
        // NOT
        app.buttons["NOT"].tap()
        
        let notString = String(repeating: "1", count: 60) + "0011"
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: notString, calculator: 1))
        
        app.buttons["NOT"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1100", calculator: 1))
    }
    
    func testCompliments() throws {
        let app = XCUIApplication()
        
        app.buttons["11"].tap()
        app.buttons["11"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1111", calculator: 1))
        
        // 1's compliment
        var onesCompString = String(repeating: "1", count: 60) + "0000"
        
        app.buttons["1's"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: onesCompString, calculator: 1))
        
        app.buttons["1's"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1111", calculator: 1))
        
        app.buttons["AC"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 1))
        
        onesCompString = String(repeating: "1", count: 64)
        
        app.buttons["1's"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: onesCompString, calculator: 1))
        
        app.buttons["1's"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 1))
        
        // 2's compliment
        
        app.buttons["2's"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 1))
        
        app.buttons["2's"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 1))
        
        app.buttons["11"].tap()
        app.buttons["11"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1111", calculator: 1))
        
        let twosCompString = String(repeating: "1", count: 60) + "0001"
        
        app.buttons["2's"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: twosCompString, calculator: 1))
        
        app.buttons["2's"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1111", calculator: 1))
    }
    
    func testShifts() throws {
        let app = XCUIApplication()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 1))
        
        app.buttons["<<"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 1))
        
        app.buttons[">>"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 1))
        
        app.buttons["1"].tap()
        app.buttons["0"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "10", calculator: 1))
        
        app.buttons["<<"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "100", calculator: 1))
        
        app.buttons[">>"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "10", calculator: 1))
        
        app.buttons[">>"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1", calculator: 1))
        
        app.buttons[">>"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 1))
        
        var expectedString = ""
        for _ in 0..<31 {
            app.buttons["11"].tap()
            expectedString.append("11")
        }
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: expectedString, calculator: 1))
        
        app.buttons["<<"].tap()
        expectedString.append("0")
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: expectedString, calculator: 1))
        
        app.buttons["<<"].tap()
        expectedString.append("0")
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: expectedString, calculator: 1))
        
        app.buttons["<<"].tap()
        expectedString.remove(at: expectedString.startIndex)
        expectedString.append("0")
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: expectedString, calculator: 1))
        
        app.buttons[">>"].tap()
        expectedString.removeLast()
        expectedString = "0" + expectedString
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: expectedString, calculator: 1))
        
        app.buttons[">>"].tap()
        expectedString.removeLast()
        expectedString = "0" + expectedString
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: expectedString, calculator: 1))
    }
}
