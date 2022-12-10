//
//  BinaryHexaCalcUITests.swift
//  HexaCalcUITests
//
//  Created by Anthony Hopkins on 2022-12-09.
//  Copyright © 2022 Anthony Hopkins. All rights reserved.
//

import XCTest
import UIKit

class DecimalHexaCalcUITests: XCTestCase {
    
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
}
