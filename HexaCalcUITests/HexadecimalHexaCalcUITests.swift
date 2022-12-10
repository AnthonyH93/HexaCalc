//
//  HexadecimalHexaCalcUITests.swift
//  HexadecimalHexaCalcUITests
//
//  Created by Anthony Hopkins on 2022-11-12.
//  Copyright © 2022 Anthony Hopkins. All rights reserved.
//

import XCTest
import UIKit

class HexadecimalHexaCalcUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDeletion() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Launched on Hexadecimal tab
        app.buttons["A"].tap()
        for _ in 0..<5 {
            app.buttons["B"].tap()
        }
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "ABBBBB", calculator: 0))
        
        // Test delete button
        app.buttons["DEL"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "ABBBB", calculator: 0))
        
        // Test delete gesture
        app.staticTexts["ABBBB"].swipeLeft()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "ABBB", calculator: 0))
        
        // Test delete after computation
        app.buttons["+"].tap()
        app.buttons["A"].tap()
        app.buttons["="].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "ABC5", calculator: 0))
        
        app.buttons["DEL"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 0))
    }
    
    func testIntegerOverflow() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Launched on Hexadecimal tab
        app.buttons["7"].tap()
        for _ in 0..<15 {
            app.buttons["F"].tap()
        }
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "7FFFFFFFFFFFFFFF", calculator: 0))
        
        app.buttons["×"].tap()
        app.buttons["F"].tap()
        app.buttons["="].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "Error! Integer Overflow!", calculator: 0))
        
        app.buttons["AC"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 0))
    }
    
    func testAllNumberButtons() throws {
        let app = XCUIApplication()
        app.launch()
        
        let digits = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "0"]
        
        for digit in digits {
            app.buttons[digit].tap()
        }
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: digits.joined(), calculator: 0))
    }
    
    func testXOR() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["A"].tap()
        app.buttons["B"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "AB", calculator: 0))
        
        app.buttons["XOR"].tap()
        
        app.buttons["C"].tap()
        app.buttons["D"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "CD", calculator: 0))
        
        app.buttons["="].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "66", calculator: 0))
    }
    
    func testOR() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["A"].tap()
        app.buttons["B"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "AB", calculator: 0))
        
        app.buttons["OR"].tap()
        
        app.buttons["C"].tap()
        app.buttons["D"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "CD", calculator: 0))
        
        app.buttons["="].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "EF", calculator: 0))
    }
    
    func testAND() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["A"].tap()
        app.buttons["B"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "AB", calculator: 0))
        
        app.buttons["AND"].tap()
        
        app.buttons["C"].tap()
        app.buttons["D"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "CD", calculator: 0))
        
        app.buttons["="].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "89", calculator: 0))
    }
    
    func testNOT() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["A"].tap()
        app.buttons["B"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "AB", calculator: 0))
        
        app.buttons["NOT"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "FFFFFFFFFFFFFF54", calculator: 0))
        
        app.buttons["NOT"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "AB", calculator: 0))
        
        app.buttons["AC"].tap()
        
        app.buttons["NOT"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "FFFFFFFFFFFFFFFF", calculator: 0))
        
        app.buttons["AC"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 0))
    }
    
    func testSecondFunctionsUI() throws {
        let app = XCUIApplication()
        app.launch()
        
        let basicFunctions = ["÷", "×", "-", "+", "="]
        let secondFunctions = ["2's", "MOD", "<<X", ">>X", "="]
        
        for function in basicFunctions {
            XCTAssert(app.buttons[function].exists)
        }
        
        app.buttons["2nd"].tap()
        
        for function in secondFunctions {
            XCTAssert(app.buttons[function].exists)
        }
     
        app.buttons["2nd"].tap()
        
        for function in basicFunctions {
            XCTAssert(app.buttons[function].exists)
        }
    }
    
    func test2sCompliment() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["2nd"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 0))
        
        app.buttons["2's"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 0))
        
        app.buttons["1"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1", calculator: 0))
        
        app.buttons["2's"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "FFFFFFFFFFFFFFFF", calculator: 0))
        
        app.buttons["2's"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1", calculator: 0))
    }
    
    func testMOD() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["2nd"].tap()
        
        app.buttons["A"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "A", calculator: 0))
        
        app.buttons["MOD"].tap()
        
        app.buttons["0"].tap()
        
        app.buttons["="].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "Error!", calculator: 0))
        
        app.buttons["AC"].tap()
        
        app.buttons["A"].tap()
        
        app.buttons["MOD"].tap()
        
        app.buttons["1"].tap()
        
        app.buttons["="].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 0))
        
        app.buttons["MOD"].tap()
        
        app.buttons["2"].tap()
        
        app.buttons["="].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 0))
        
        app.buttons["AC"].tap()
        
        app.buttons["A"].tap()
        
        app.buttons["MOD"].tap()
        
        app.buttons["6"].tap()
        
        app.buttons["="].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "4", calculator: 0))
        
        app.buttons["MOD"].tap()
        
        app.buttons["6"].tap()
        app.buttons["4"].tap()
        
        app.buttons["="].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "4", calculator: 0))
        
        app.buttons["MOD"].tap()
        
        app.buttons["2"].tap()
        
        app.buttons["="].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 0))
    }
    
    func testShifts() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["2nd"].tap()
        
        app.buttons["8"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "8", calculator: 0))
        
        app.buttons["<<X"].tap()
        
        app.buttons["2"].tap()
        
        app.buttons["="].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "20", calculator: 0))
        
        app.buttons[">>X"].tap()
        
        app.buttons["2"].tap()
        
        app.buttons["="].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "8", calculator: 0))
        
        app.buttons["<<X"].tap()
        
        app.buttons["1"].tap()
        app.buttons["5"].tap()
        
        app.buttons["="].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1000000", calculator: 0))
    }
}
