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

    func testThemeColourChange() throws {
        let app = XCUIApplication()

        // Navigate to Colour selection
        app.tables.staticTexts["Colour"].tap()

        // The selection list shows ["Red", "Orange", "Yellow", "Green", "Blue", "Teal", "Indigo", "Violet", "Pink", "Brown"]
        // Select "Red" (first option)
        app.tables.staticTexts["Red"].tap()

        // Go back to settings
        app.navigationBars.buttons.firstMatch.tap()

        // Colour cell should now show "Red" as the selection
        XCTAssert(app.staticTexts["Red"].exists)

        // Restore to Green (default)
        app.tables.staticTexts["Colour"].tap()
        app.tables.staticTexts["Green"].tap()
        app.navigationBars.buttons.firstMatch.tap()

        XCTAssert(app.staticTexts["Green"].exists)
    }

    func testDefaultTabSetting() throws {
        let app = XCUIApplication()

        // Navigate to Default Selected Tab selection
        app.tables.staticTexts["Override Default Selected Tab"].tap()

        // The selection list shows ["Hexadecimal", "Binary", "Decimal", "Off"]
        // Select "Binary"
        app.tables.staticTexts["Binary"].tap()

        // Go back to settings
        app.navigationBars.buttons.firstMatch.tap()

        // The cell summary should now show "Binary"
        XCTAssert(app.staticTexts["Binary"].exists)

        // Restore to Off (default)
        app.tables.staticTexts["Override Default Selected Tab"].tap()
        app.tables.staticTexts["Off"].tap()
        app.navigationBars.buttons.firstMatch.tap()

        XCTAssert(app.staticTexts["Off"].exists)
    }
}
