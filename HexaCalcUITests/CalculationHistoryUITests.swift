//
//  CalculationHistoryUITests.swift
//  HexaCalcUITests
//
//  Created by Anthony Hopkins on 2026-04-30.
//  Copyright © 2026 Anthony Hopkins. All rights reserved.
//

import XCTest
import UIKit

class CalculationHistoryUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        let app = XCUIApplication()
        guard app.tabBars["Tab Bar"].waitForExistence(timeout: 2) else { return }

        app.tabBars["Tab Bar"].buttons["Settings"].tap()

        // Re-enable history if a test left it disabled
        let historySw = app.switches["Calculation History"]
        if historySw.exists, (historySw.value as? String) == "0" {
            historySw.tap()
        }

        // Restore History Button View to Icon Image if a test changed it
        let historyButtonViewCell = app.tables.staticTexts["History Button View"]
        if historyButtonViewCell.waitForExistence(timeout: 2) {
            historyButtonViewCell.tap()
            app.tables.staticTexts["Icon Image"].tap()
            // If already on Icon Image the selection screen won't auto-pop — go back manually
            if app.navigationBars["History Button View"].waitForExistence(timeout: 1) {
                app.navigationBars["History Button View"].buttons["Settings"].tap()
            }
        }
    }

    func testCalculationHistoryButton() throws {
        let app = XCUIApplication()
        app.launch()

        // App may start on a non-Hex tab due to persisted UserDefaults from prior runs
        app.tabBars["Tab Bar"].buttons["Hexadecimal"].tap()

        // History button should be visible by default (icon mode)
        let historyButton = app.buttons["History Button"]
        XCTAssert(historyButton.exists)
        XCTAssert(historyButton.isHittable)

        historyButton.tap()

        // Calculation History view should appear
        XCTAssert(app.staticTexts["Calculation History"].waitForExistence(timeout: 2))
    }

    func testCalculationHistoryPopulatedAfterOperations() throws {
        let app = XCUIApplication()
        app.launch()

        // App may start on a non-Hex tab due to persisted UserDefaults from prior runs
        app.tabBars["Tab Bar"].buttons["Hexadecimal"].tap()

        // Perform a calculation so history is non-empty
        app.buttons["A"].tap()
        UITestHelper.add(app: app)
        app.buttons["B"].tap()
        UITestHelper.equals(app: app)

        XCTAssert(UITestHelper.assertResult(app: app, expected: "15", calculator: 0))

        // Perform a second calculation
        UITestHelper.multiply(app: app)
        app.buttons["2"].tap()
        UITestHelper.equals(app: app)

        XCTAssert(UITestHelper.assertResult(app: app, expected: "2A", calculator: 0))

        // Open history view
        app.buttons["History Button"].tap()

        XCTAssert(app.staticTexts["Calculation History"].waitForExistence(timeout: 2))

        // At least one history cell should be present
        let cells = app.tables.cells
        XCTAssert(cells.count > 0)
    }

    func testCalculationHistoryCopyToClipboard() throws {
        let app = XCUIApplication()
        app.launch()

        let tabBar = app.tabBars["Tab Bar"]

        // Ensure history is enabled — UserDefaults may persist disabled state from prior runs
        tabBar.buttons["Settings"].tap()
        let historySw = app.switches["Calculation History"]
        if (historySw.value as? String) == "0" { historySw.tap() }

        tabBar.buttons["Hexadecimal"].tap()

        // Perform a calculation to ensure history is non-empty
        app.buttons["A"].tap()
        UITestHelper.add(app: app)
        app.buttons["B"].tap()
        UITestHelper.equals(app: app)

        app.buttons["History Button"].tap()
        XCTAssert(app.staticTexts["Calculation History"].waitForExistence(timeout: 2))

        // Tapping a cell copies the result and shows a confirmation alert
        // Scope to the first (frontmost) table — the presented history sheet
        let historyTable = app.tables.firstMatch
        XCTAssert(historyTable.waitForExistence(timeout: 3))
        let firstCell = historyTable.cells.firstMatch
        XCTAssert(firstCell.waitForExistence(timeout: 3))
        firstCell.tap()

        XCTAssert(app.alerts["Copied to clipboard"].waitForExistence(timeout: 4))
        // Alert auto-dismisses after 1.5 seconds — no button to tap
    }

    func testHistoryEnabledToggleHidesButton() throws {
        let app = XCUIApplication()
        app.launch()
        let tabBar = app.tabBars["Tab Bar"]

        // Ensure history starts enabled
        tabBar.buttons["Settings"].tap()
        let historySw = app.switches["Calculation History"]
        if (historySw.value as? String) == "0" { historySw.tap() }

        // History button is visible on the Hexadecimal tab
        tabBar.buttons["Hexadecimal"].tap()
        let historyButton = app.buttons["History Button"]
        XCTAssert(historyButton.waitForExistence(timeout: 2))
        XCTAssert(historyButton.isHittable)

        // Disable history — button should disappear
        tabBar.buttons["Settings"].tap()
        app.switches["Calculation History"].tap()
        XCTAssertEqual(app.switches["Calculation History"].value as? String, "0")

        tabBar.buttons["Hexadecimal"].tap()
        XCTAssertFalse(app.buttons["History Button"].exists)

        // Re-enable history — button should reappear
        tabBar.buttons["Settings"].tap()
        app.switches["Calculation History"].tap()
        XCTAssertEqual(app.switches["Calculation History"].value as? String, "1")

        tabBar.buttons["Hexadecimal"].tap()
        XCTAssert(app.buttons["History Button"].waitForExistence(timeout: 2))
        XCTAssert(app.buttons["History Button"].isHittable)
    }

    func testDisablingHistoryClearsAndStopsRecording() throws {
        let app = XCUIApplication()
        app.launch()
        let tabBar = app.tabBars["Tab Bar"]

        // Ensure history starts enabled
        tabBar.buttons["Settings"].tap()
        let historySw = app.switches["Calculation History"]
        if (historySw.value as? String) == "0" { historySw.tap() }

        // Perform a calculation to populate history
        tabBar.buttons["Hexadecimal"].tap()
        app.buttons["A"].tap()
        UITestHelper.add(app: app)
        app.buttons["B"].tap()
        UITestHelper.equals(app: app)

        app.buttons["History Button"].tap()
        XCTAssert(app.staticTexts["Calculation History"].waitForExistence(timeout: 2))
        XCTAssert(app.tables.cells.count > 0)
        app.buttons["close"].tap()

        // Disable history — clears existing history
        tabBar.buttons["Settings"].tap()
        app.switches["Calculation History"].tap()
        XCTAssertEqual(app.switches["Calculation History"].value as? String, "0")

        // Perform more calculations while history is off
        tabBar.buttons["Hexadecimal"].tap()
        app.buttons["1"].tap()
        UITestHelper.add(app: app)
        app.buttons["2"].tap()
        UITestHelper.equals(app: app)

        // Re-enable history
        tabBar.buttons["Settings"].tap()
        app.switches["Calculation History"].tap()
        XCTAssertEqual(app.switches["Calculation History"].value as? String, "1")

        // History should be empty — cleared on disable, nothing recorded while off
        tabBar.buttons["Hexadecimal"].tap()
        app.buttons["History Button"].tap()
        XCTAssert(app.staticTexts["Calculation History"].waitForExistence(timeout: 2))
        XCTAssertEqual(app.tables.cells.count, 0)
    }

    func testHistoryButtonViewOnlyShowsTwoOptions() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars["Tab Bar"].buttons["Settings"].tap()

        // Ensure history is enabled so the row is interactive
        let historySw = app.switches["Calculation History"]
        if (historySw.value as? String) == "0" { historySw.tap() }

        app.tables.staticTexts["History Button View"].tap()

        // Only Icon Image and Text Label should be present — Off was removed
        XCTAssert(app.tables.staticTexts["Icon Image"].waitForExistence(timeout: 2))
        XCTAssert(app.tables.staticTexts["Text Label"].exists)
        XCTAssertFalse(app.tables.staticTexts["Off"].exists)

        // Navigate back without making a change
        app.navigationBars.buttons["Settings"].tap()
    }

    func testHistoryButtonViewTextLabel() throws {
        let app = XCUIApplication()
        app.launch()
        let tabBar = app.tabBars["Tab Bar"]

        // Ensure history is enabled
        tabBar.buttons["Settings"].tap()
        let historySw = app.switches["Calculation History"]
        if (historySw.value as? String) == "0" { historySw.tap() }

        // Switch button view to Text Label
        app.tables.staticTexts["History Button View"].tap()
        app.tables.staticTexts["Text Label"].tap()

        // Confirm summary updated on Settings screen
        XCTAssert(app.staticTexts["Text Label"].waitForExistence(timeout: 2))

        // History button should still be visible and tappable on the Hexadecimal tab
        tabBar.buttons["Hexadecimal"].tap()
        let historyButton = app.buttons["History Button"]
        XCTAssert(historyButton.waitForExistence(timeout: 2))
        XCTAssert(historyButton.isHittable)

        historyButton.tap()
        XCTAssert(app.staticTexts["Calculation History"].waitForExistence(timeout: 2))
        app.buttons["close"].tap()
    }
}
