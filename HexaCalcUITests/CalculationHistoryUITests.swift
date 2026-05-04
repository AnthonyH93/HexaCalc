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

        app.tabBars["Tab Bar"].buttons["Hexadecimal"].tap()

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
}
