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
        UITestHelper.delete(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "ABBBB", calculator: 0))
        
        // Test delete gesture
        app.staticTexts["ABBBB"].swipeLeft()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "ABBB", calculator: 0))
        
        // Test delete after computation
        UITestHelper.add(app: app)
        app.buttons["A"].tap()
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "ABC5", calculator: 0))
        
        UITestHelper.delete(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "ABC5", calculator: 0))
        
        // Test deleting entire string
        UITestHelper.clear(app: app)
        app.buttons["1"].tap()
        app.buttons["1"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "11", calculator: 0))
        
        UITestHelper.delete(app: app)
        UITestHelper.delete(app: app)
        
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
        
        UITestHelper.multiply(app: app)
        app.buttons["F"].tap()
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "Error! Integer Overflow!", calculator: 0))
        
        UITestHelper.clear(app: app)
        
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
        
        UITestHelper.xor(app: app)
        
        app.buttons["C"].tap()
        app.buttons["D"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "CD", calculator: 0))
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "66", calculator: 0))
    }
    
    func testOR() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["A"].tap()
        app.buttons["B"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "AB", calculator: 0))
        
        UITestHelper.or(app: app)
        
        app.buttons["C"].tap()
        app.buttons["D"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "CD", calculator: 0))
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "EF", calculator: 0))
    }
    
    func testAND() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["A"].tap()
        app.buttons["B"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "AB", calculator: 0))
        
        UITestHelper.and(app: app)
        
        app.buttons["C"].tap()
        app.buttons["D"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "CD", calculator: 0))
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "89", calculator: 0))
    }
    
    func testNOT() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["A"].tap()
        app.buttons["B"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "AB", calculator: 0))
        
        UITestHelper.not(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "FFFFFFFFFFFFFF54", calculator: 0))
        
        UITestHelper.not(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "AB", calculator: 0))
        
        UITestHelper.clear(app: app)
        
        UITestHelper.not(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "FFFFFFFFFFFFFFFF", calculator: 0))
        
        UITestHelper.clear(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 0))
    }
    
    func testSecondFunctionsUI() throws {
        let app = XCUIApplication()
        app.launch()
        
        let basicFunctions = [UITestHelper.divide, UITestHelper.multiply, UITestHelper.subtract, UITestHelper.add, UITestHelper.equals]
        let secondFunctions = ["2's", "MOD", "<<X", ">>X", UITestHelper.equals]
        
        for function in basicFunctions {
            XCTAssert(app.buttons[function].exists)
        }
        
        UITestHelper.second(app: app)
        
        for function in secondFunctions {
            XCTAssert(app.buttons[function].exists)
        }
     
        UITestHelper.second(app: app)
        
        for function in basicFunctions {
            XCTAssert(app.buttons[function].exists)
        }
    }
    
    func test2sCompliment() throws {
        let app = XCUIApplication()
        app.launch()
        
        UITestHelper.second(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 0))
        
        UITestHelper.twos(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 0))
        
        app.buttons["1"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1", calculator: 0))
        
        UITestHelper.twos(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "FFFFFFFFFFFFFFFF", calculator: 0))
        
        UITestHelper.twos(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1", calculator: 0))
    }
    
    func testMOD() throws {
        let app = XCUIApplication()
        app.launch()
        
        UITestHelper.second(app: app)
        
        app.buttons["A"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "A", calculator: 0))
        
        UITestHelper.mod(app: app)
        
        app.buttons["0"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "Error!", calculator: 0))
        
        UITestHelper.clear(app: app)
        
        app.buttons["A"].tap()
        
        UITestHelper.mod(app: app)
        
        app.buttons["1"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 0))
        
        UITestHelper.mod(app: app)
        
        app.buttons["2"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 0))
        
        UITestHelper.clear(app: app)
        
        app.buttons["A"].tap()
        
        UITestHelper.mod(app: app)
        
        app.buttons["6"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "4", calculator: 0))
        
        UITestHelper.mod(app: app)
        
        app.buttons["6"].tap()
        app.buttons["4"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "4", calculator: 0))
        
        UITestHelper.mod(app: app)
        
        app.buttons["2"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 0))
    }
    
    func testShifts() throws {
        let app = XCUIApplication()
        app.launch()
        
        UITestHelper.second(app: app)
        
        app.buttons["8"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "8", calculator: 0))
        
        UITestHelper.leftShiftX(app: app)
        
        app.buttons["2"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "20", calculator: 0))
        
        UITestHelper.rightShiftX(app: app)
        
        app.buttons["2"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "8", calculator: 0))
        
        UITestHelper.leftShiftX(app: app)
        
        app.buttons["1"].tap()
        app.buttons["5"].tap()
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1000000", calculator: 0))
    }
}
