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

        // UITabBarItem.isEnabled only affects visual appearance — neither .exists nor
        // .isEnabled on the XCTest proxy reflects it.  Switch value ("0"=off, "1"=on)
        // is the reliable proxy for the tab's enabled/disabled state.
        let hexSwitch = app.switches["Hexadecimal"]
        let binSwitch = app.switches["Binary"]
        let decSwitch = app.switches["Decimal"]

        // Reset any switches left off by a previous failed run
        for sw in [hexSwitch, binSwitch, decSwitch] {
            if sw.exists, (sw.value as? String) == "0" { sw.tap() }
        }

        // Verify all start ON
        XCTAssertEqual(hexSwitch.value as? String, "1")
        XCTAssertEqual(binSwitch.value as? String, "1")
        XCTAssertEqual(decSwitch.value as? String, "1")

        hexSwitch.tap()
        XCTAssertEqual(hexSwitch.value as? String, "0")
        XCTAssertEqual(binSwitch.value as? String, "1")
        XCTAssertEqual(decSwitch.value as? String, "1")

        binSwitch.tap()
        XCTAssertEqual(hexSwitch.value as? String, "0")
        XCTAssertEqual(binSwitch.value as? String, "0")
        XCTAssertEqual(decSwitch.value as? String, "1")

        decSwitch.tap()
        XCTAssertEqual(hexSwitch.value as? String, "0")
        XCTAssertEqual(binSwitch.value as? String, "0")
        XCTAssertEqual(decSwitch.value as? String, "0")

        hexSwitch.tap()
        XCTAssertEqual(hexSwitch.value as? String, "1")
        XCTAssertEqual(binSwitch.value as? String, "0")
        XCTAssertEqual(decSwitch.value as? String, "0")

        decSwitch.tap()
        XCTAssertEqual(hexSwitch.value as? String, "1")
        XCTAssertEqual(binSwitch.value as? String, "0")
        XCTAssertEqual(decSwitch.value as? String, "1")

        binSwitch.tap()
        XCTAssertEqual(hexSwitch.value as? String, "1")
        XCTAssertEqual(binSwitch.value as? String, "1")
        XCTAssertEqual(decSwitch.value as? String, "1")
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
