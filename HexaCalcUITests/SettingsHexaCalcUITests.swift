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

        // Reset any tab switches left disabled by a previous failed run, then load the
        // Hexadecimal VC so that tab-enable/disable actions work correctly in all tests.
        tabBar.buttons["Settings"].tap()
        for name in ["Hexadecimal", "Binary", "Decimal"] {
            let sw = app.switches[name]
            if sw.exists, (sw.value as? String) == "0" {
                sw.tap()
            }
        }
        tabBar.buttons["Hexadecimal"].tap()
        tabBar.buttons["Settings"].tap()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    func testTabDisabling() throws {
        let app = XCUIApplication()
        let tabBar = app.tabBars["Tab Bar"]

        // Reset any switches left off by a previous failed run
        for name in ["Hexadecimal", "Binary", "Decimal"] {
            let sw = app.switches[name]
            if sw.exists, (sw.value as? String) == "0" { sw.tap() }
        }

<<<<<<< HEAD
        // All tabs visible at start
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
=======
        // Ensure all tabs are enabled at start
        // isEnabled reflects UITabBarItem.isEnabled; exists is always true even when disabled
        XCTAssert(tabBar.buttons["Hexadecimal"].isEnabled)
        XCTAssert(tabBar.buttons["Binary"].isEnabled)
        XCTAssert(tabBar.buttons["Decimal"].isEnabled)
        XCTAssert(tabBar.buttons["Settings"].isEnabled)

        app.switches["Hexadecimal"].tap()
        XCTAssertFalse(tabBar.buttons["Hexadecimal"].isEnabled)
        XCTAssert(tabBar.buttons["Binary"].isEnabled)
        XCTAssert(tabBar.buttons["Decimal"].isEnabled)
        XCTAssert(tabBar.buttons["Settings"].isEnabled)

        app.switches["Binary"].tap()
        XCTAssertFalse(tabBar.buttons["Hexadecimal"].isEnabled)
        XCTAssertFalse(tabBar.buttons["Binary"].isEnabled)
        XCTAssert(tabBar.buttons["Decimal"].isEnabled)
        XCTAssert(tabBar.buttons["Settings"].isEnabled)

        app.switches["Decimal"].tap()
        XCTAssertFalse(tabBar.buttons["Hexadecimal"].isEnabled)
        XCTAssertFalse(tabBar.buttons["Binary"].isEnabled)
        XCTAssertFalse(tabBar.buttons["Decimal"].isEnabled)
        XCTAssert(tabBar.buttons["Settings"].isEnabled)

        app.switches["Hexadecimal"].tap()
        XCTAssert(tabBar.buttons["Hexadecimal"].isEnabled)
        XCTAssertFalse(tabBar.buttons["Binary"].isEnabled)
        XCTAssertFalse(tabBar.buttons["Decimal"].isEnabled)
        XCTAssert(tabBar.buttons["Settings"].isEnabled)

        app.switches["Decimal"].tap()
        XCTAssert(tabBar.buttons["Hexadecimal"].isEnabled)
        XCTAssertFalse(tabBar.buttons["Binary"].isEnabled)
        XCTAssert(tabBar.buttons["Decimal"].isEnabled)
        XCTAssert(tabBar.buttons["Settings"].isEnabled)
>>>>>>> 0f440d1... Fix testTabDisabling to use isEnabled instead of exists

        app.switches["Binary"].tap()
        XCTAssert(tabBar.buttons["Hexadecimal"].isEnabled)
        XCTAssert(tabBar.buttons["Binary"].isEnabled)
        XCTAssert(tabBar.buttons["Decimal"].isEnabled)
        XCTAssert(tabBar.buttons["Settings"].isEnabled)
    }

    func testThemeColourChange() throws {
        let app = XCUIApplication()

        // Navigate to Colour selection — tapping a row auto-pops back to Settings
        app.tables.staticTexts["Colour"].tap()

        // The selection list shows ["Red", "Orange", "Yellow", "Green", "Blue", "Teal", "Indigo", "Violet", "Pink", "Brown"]
        // Select "Red" — this saves the selection and automatically navigates back
        app.tables.staticTexts["Red"].tap()

        // Back on Settings — colour cell summary should now show "Red"
        XCTAssert(app.staticTexts["Red"].waitForExistence(timeout: 2))

        // Restore to Green (default) — same auto-pop pattern
        app.tables.staticTexts["Colour"].tap()
        app.tables.staticTexts["Green"].tap()

        XCTAssert(app.staticTexts["Green"].waitForExistence(timeout: 2))
    }

    func testDefaultTabSetting() throws {
        let app = XCUIApplication()

        // Navigate to Default Selected Tab selection — tapping a row auto-pops back
        app.tables.staticTexts["Override Default Selected Tab"].tap()

        // The selection list shows ["Hexadecimal", "Binary", "Decimal", "Off"]
        // Select "Decimal" and auto-pop back to Settings
        app.tables.staticTexts["Decimal"].tap()

        // Navigate back into the selection to restore to Off
        app.tables.staticTexts["Override Default Selected Tab"].tap()
        app.tables.staticTexts["Off"].tap()

        // "Off" is unique to the summary — not a tab switch label
        XCTAssert(app.staticTexts["Off"].waitForExistence(timeout: 2))
    }
}
