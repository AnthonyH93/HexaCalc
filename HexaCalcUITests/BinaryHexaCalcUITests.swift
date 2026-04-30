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
        UITestHelper.delete(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "10000", calculator: 1))
        
        // Test delete gesture
        app.buttons["Binary Output Label"].swipeLeft()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1000", calculator: 1))
        
        // Test delete after computation
        UITestHelper.add(app: app)
        app.buttons["1"].tap()
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1001", calculator: 1))
        
        UITestHelper.delete(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1001", calculator: 1))
        
        // Test deleting entire string
        UITestHelper.clear(app: app)
        app.buttons["1"].tap()
        app.buttons["1"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "11", calculator: 1))
        
        UITestHelper.delete(app: app)
        UITestHelper.delete(app: app)
        
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
        
        UITestHelper.multiply(app: app)
        app.buttons["11"].tap()
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "Error! Integer Overflow!", calculator: 1))
        
        UITestHelper.clear(app: app)
        
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
        UITestHelper.xor(app: app)
        
        app.buttons["11"].tap()
        app.buttons["00"].tap()
        app.buttons["0"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "11000", calculator: 1))
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "10100", calculator: 1))
        
        // OR
        UITestHelper.or(app: app)
        
        app.buttons["11"].tap()
        app.buttons["00"].tap()
        app.buttons["1"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "11001", calculator: 1))
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "11101", calculator: 1))
        
        // AND
        UITestHelper.and(app: app)
        
        app.buttons["11"].tap()
        app.buttons["1"].tap()
        app.buttons["0"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1110", calculator: 1))
        
        UITestHelper.equals(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1100", calculator: 1))
        
        // NOT
        UITestHelper.not(app: app)
        
        let notString = String(repeating: "1", count: 60) + "0011"
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: notString, calculator: 1))
        
        UITestHelper.not(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1100", calculator: 1))
    }
    
    func testCompliments() throws {
        let app = XCUIApplication()
        
        app.buttons["11"].tap()
        app.buttons["11"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1111", calculator: 1))
        
        // 1's compliment
        var onesCompString = String(repeating: "1", count: 60) + "0000"
        
        UITestHelper.ones(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: onesCompString, calculator: 1))
        
        UITestHelper.ones(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1111", calculator: 1))
        
        UITestHelper.clear(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 1))
        
        onesCompString = String(repeating: "1", count: 64)
        
        UITestHelper.ones(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: onesCompString, calculator: 1))
        
        UITestHelper.ones(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 1))
        
        // 2's compliment
        
        UITestHelper.twos(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 1))
        
        UITestHelper.twos(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 1))
        
        app.buttons["11"].tap()
        app.buttons["11"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1111", calculator: 1))
        
        let twosCompString = String(repeating: "1", count: 60) + "0001"
        
        UITestHelper.twos(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: twosCompString, calculator: 1))
        
        UITestHelper.twos(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1111", calculator: 1))
    }
    
    func testShifts() throws {
        let app = XCUIApplication()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 1))
        
        UITestHelper.leftShift(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 1))
        
        UITestHelper.rightShift(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 1))
        
        app.buttons["1"].tap()
        app.buttons["0"].tap()
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "10", calculator: 1))
        
        UITestHelper.leftShift(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "100", calculator: 1))
        
        UITestHelper.rightShift(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "10", calculator: 1))
        
        UITestHelper.rightShift(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1", calculator: 1))
        
        UITestHelper.rightShift(app: app)
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 1))
        
        var expectedString = ""
        for _ in 0..<31 {
            app.buttons["11"].tap()
            expectedString.append("11")
        }
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: expectedString, calculator: 1))
        
        UITestHelper.leftShift(app: app)
        expectedString.append("0")
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: expectedString, calculator: 1))
        
        UITestHelper.leftShift(app: app)
        expectedString.append("0")
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: expectedString, calculator: 1))
        
        UITestHelper.leftShift(app: app)
        expectedString.remove(at: expectedString.startIndex)
        expectedString.append("0")
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: expectedString, calculator: 1))
        
        UITestHelper.rightShift(app: app)
        expectedString.removeLast()
        expectedString = "0" + expectedString
        
        XCTAssert(UITestHelper.assertResult(app: app, expected: expectedString, calculator: 1))
        
        UITestHelper.rightShift(app: app)
        expectedString.removeLast()
        expectedString = "0" + expectedString

        XCTAssert(UITestHelper.assertResult(app: app, expected: expectedString, calculator: 1))
    }

    func testBinaryDoubleDigitButtons() throws {
        let app = XCUIApplication()

        // 00 at zero stays 0
        app.buttons["00"].tap()
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 1))

        // 11 gives 11
        app.buttons["11"].tap()
        XCTAssert(UITestHelper.assertResult(app: app, expected: "11", calculator: 1))

        // 00 appends two zeros
        app.buttons["00"].tap()
        XCTAssert(UITestHelper.assertResult(app: app, expected: "1100", calculator: 1))

        // 11 appends
        app.buttons["11"].tap()
        XCTAssert(UITestHelper.assertResult(app: app, expected: "110011", calculator: 1))

        UITestHelper.clear(app: app)
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 1))

        // Fill to 62 bits, then 11 only fills remaining 2 slots (stays at 64)
        app.buttons["11"].tap()
        var expectedString = "11"
        for _ in 0..<30 {
            app.buttons["11"].tap()
            expectedString.append("11")
        }
        // At 62 bits, pressing 11 should add only 2 more to reach 64
        app.buttons["11"].tap()
        expectedString.append("11")

        XCTAssert(UITestHelper.assertResult(app: app, expected: expectedString, calculator: 1))
        XCTAssertEqual(expectedString.count, 64)

        // Pressing 11 again should not change (at max 64 bits)
        app.buttons["11"].tap()
        XCTAssert(UITestHelper.assertResult(app: app, expected: expectedString, calculator: 1))
    }

    func testBinaryShiftThenArithmetic() throws {
        let app = XCUIApplication()

        // Enter 10 (binary 2), left shift to 100 (binary 4)
        app.buttons["1"].tap()
        app.buttons["0"].tap()

        XCTAssert(UITestHelper.assertResult(app: app, expected: "10", calculator: 1))

        UITestHelper.leftShift(app: app)

        XCTAssert(UITestHelper.assertResult(app: app, expected: "100", calculator: 1))

        // Add 11 (binary 3): 4 + 3 = 7 = 111 in binary
        UITestHelper.add(app: app)
        app.buttons["11"].tap()
        UITestHelper.equals(app: app)

        XCTAssert(UITestHelper.assertResult(app: app, expected: "111", calculator: 1))

        // Multiply by 10 (binary 2): 7 * 2 = 14 = 1110 in binary
        UITestHelper.multiply(app: app)
        app.buttons["1"].tap()
        app.buttons["0"].tap()
        UITestHelper.equals(app: app)

        XCTAssert(UITestHelper.assertResult(app: app, expected: "1110", calculator: 1))

        UITestHelper.clear(app: app)
        XCTAssert(UITestHelper.assertResult(app: app, expected: "0", calculator: 1))
    }
}
