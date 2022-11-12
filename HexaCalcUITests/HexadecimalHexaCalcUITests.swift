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
        // UI tests must launch the application that they test.
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
        
        XCTAssert(!app.staticTexts["ABC5"].exists)
    }
}
