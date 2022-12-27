//
//  SettingsHexaCalcUITests.swift
//  HexaCalcUITests
//
//  Created by Anthony Hopkins on 2022-12-15.
//  Copyright © 2022 Anthony Hopkins. All rights reserved.
//

import XCTest
import UIKit

class SettingsHexaCalcUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Navigate to the settings tab before running each test
        
        let app = XCUIApplication()
        app.launch()
        
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Settings"].tap()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }
    
    func testTabDisabling() throws {
        let app = XCUIApplication()
        let tabBar = app.tabBars["Tab Bar"]
        
        // Ensure all tabs appear at start
        XCTAssert(tabBar.buttons["Hexadecimal"].exists)
        XCTAssert(tabBar.buttons["Binary"].exists)
        XCTAssert(tabBar.buttons["Decimal"].exists)
        XCTAssert(tabBar.buttons["Settings"].exists)
        
        app.switches["Hexadecimal"].tap()
        XCTAssertFalse(tabBar.buttons["Hexadecimal"].exists)
        XCTAssert(tabBar.buttons["Binary"].exists)
        XCTAssert(tabBar.buttons["Decimal"].exists)
        XCTAssert(tabBar.buttons["Settings"].exists)
        
        app.switches["Binary"].tap()
        XCTAssertFalse(tabBar.buttons["Hexadecimal"].exists)
        XCTAssertFalse(tabBar.buttons["Binary"].exists)
        XCTAssert(tabBar.buttons["Decimal"].exists)
        XCTAssert(tabBar.buttons["Settings"].exists)
        
        app.switches["Decimal"].tap()
        XCTAssertFalse(tabBar.buttons["Hexadecimal"].exists)
        XCTAssertFalse(tabBar.buttons["Binary"].exists)
        XCTAssertFalse(tabBar.buttons["Decimal"].exists)
        XCTAssert(tabBar.buttons["Settings"].exists)
        
        app.switches["Hexadecimal"].tap()
        XCTAssert(tabBar.buttons["Hexadecimal"].exists)
        XCTAssertFalse(tabBar.buttons["Binary"].exists)
        XCTAssertFalse(tabBar.buttons["Decimal"].exists)
        XCTAssert(tabBar.buttons["Settings"].exists)
        
        app.switches["Decimal"].tap()
        XCTAssert(tabBar.buttons["Hexadecimal"].exists)
        XCTAssertFalse(tabBar.buttons["Binary"].exists)
        XCTAssert(tabBar.buttons["Decimal"].exists)
        XCTAssert(tabBar.buttons["Settings"].exists)
        
        app.switches["Binary"].tap()
        XCTAssert(tabBar.buttons["Hexadecimal"].exists)
        XCTAssert(tabBar.buttons["Binary"].exists)
        XCTAssert(tabBar.buttons["Decimal"].exists)
        XCTAssert(tabBar.buttons["Settings"].exists)
    }
}
