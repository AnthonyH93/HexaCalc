//
//  WordSizeUITests.swift
//  HexaCalcUITests
//
//  Created by Anthony Hopkins on 2026-11-12.
//  Copyright © 2026 Anthony Hopkins. All rights reserved.
//

import XCTest
import UIKit

class WordSizeUITests: XCTestCase {

    override func setUpWithError() throws {
        let app = XCUIApplication()
        // ReviewManager shows the App Store review prompt after the third completed
        // calculation, and that prompt swallows every tap until dismissed. A launch
        // argument overrides the UserDefaults value it counts with, pinning it at 0.
        app.launchArguments += ["-ReviewWorthyActionCount", "0"]
        app.launch()

        app.tabBars["Tab Bar"].buttons["Hexadecimal"].tap()
        // The word size is persisted, so start every test from the default
        selectWordSize(app: app, "64-bit")
        UITestHelper.clear(app: app)

        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Restore the default so other test classes run at 64 bits
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["Hexadecimal"].tap()
        selectWordSize(app: app, "64-bit")
    }

    // MARK: Helpers

    private func selectWordSize(app: XCUIApplication, _ title: String) {
        let wordSizeButton = app.buttons["Word Size Button"]
        XCTAssert(wordSizeButton.waitForExistence(timeout: 5))
        wordSizeButton.tap()

        // A tap that lands while a tab switch is still animating can fail to open the
        // menu, so try once more before giving up
        let menuItem = app.buttons[title]
        if !menuItem.waitForExistence(timeout: 3) {
            wordSizeButton.tap()
            XCTAssert(menuItem.waitForExistence(timeout: 3), "Word size menu did not open")
        }
        menuItem.tap()
    }

    private func hexLabel(app: XCUIApplication) -> String {
        app.staticTexts["Hexadecimal Output Label"].label
    }

    // Binary label digits with the nibble spacing and line breaks removed
    private func binaryDigits(app: XCUIApplication) -> String {
        app.buttons["Binary Output Label"].label.components(separatedBy: .whitespacesAndNewlines).joined()
    }

    private func type(app: XCUIApplication, _ digits: String) {
        for digit in digits {
            app.buttons[String(digit)].tap()
        }
    }

    // MARK: Tests

    func testHexadecimalWrapsAt8Bit() throws {
        let app = XCUIApplication()
        selectWordSize(app: app, "8-bit")

        // 7F + 1 wraps to the most negative 8-bit value instead of overflowing
        type(app: app, "7F")
        UITestHelper.add(app: app)
        type(app: app, "1")
        UITestHelper.equals(app: app)
        XCTAssertEqual(hexLabel(app: app), "80")

        // ...which the Decimal tab reads as signed
        app.tabBars["Tab Bar"].buttons["Decimal"].tap()
        XCTAssert(UITestHelper.assertResult(app: app, expected: "-128", calculator: 2))
        app.tabBars["Tab Bar"].buttons["Hexadecimal"].tap()

        // FF + 1 wraps to 0
        UITestHelper.clear(app: app)
        type(app: app, "FF")
        UITestHelper.add(app: app)
        type(app: app, "1")
        UITestHelper.equals(app: app)
        XCTAssertEqual(hexLabel(app: app), "0")
    }

    func testHexadecimalDigitLimitFollowsWordSize() throws {
        let app = XCUIApplication()
        selectWordSize(app: app, "8-bit")
        type(app: app, "123")
        XCTAssertEqual(hexLabel(app: app), "12")

        UITestHelper.clear(app: app)
        selectWordSize(app: app, "16-bit")
        type(app: app, "12345")
        XCTAssertEqual(hexLabel(app: app), "1234")
    }

    func testHexadecimalNotAt16Bit() throws {
        let app = XCUIApplication()
        selectWordSize(app: app, "16-bit")
        type(app: app, "1")
        UITestHelper.not(app: app)
        XCTAssertEqual(hexLabel(app: app), "FFFE")
    }

    func testShrinkingTruncatesToLowBits() throws {
        let app = XCUIApplication()
        type(app: app, "1234")
        selectWordSize(app: app, "8-bit")
        XCTAssertEqual(hexLabel(app: app), "34")

        // Every tab sees the truncated value
        app.tabBars["Tab Bar"].buttons["Binary"].tap()
        XCTAssertEqual(binaryDigits(app: app), "00110100")
        app.tabBars["Tab Bar"].buttons["Decimal"].tap()
        XCTAssert(UITestHelper.assertResult(app: app, expected: "52", calculator: 2))
    }

    func testGrowingKeepsBitPattern() throws {
        let app = XCUIApplication()
        selectWordSize(app: app, "8-bit")
        type(app: app, "A5")

        // Widening zero-extends: A5 stays A5 rather than becoming FFA5
        selectWordSize(app: app, "16-bit")
        XCTAssertEqual(hexLabel(app: app), "A5")

        app.tabBars["Tab Bar"].buttons["Binary"].tap()
        XCTAssertEqual(binaryDigits(app: app), "0000000010100101")
        app.tabBars["Tab Bar"].buttons["Decimal"].tap()
        XCTAssert(UITestHelper.assertResult(app: app, expected: "165", calculator: 2))
    }

    func testBinaryLabelShowsWordSizeDigits() throws {
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["Binary"].tap()

        for bits in [8, 16, 32, 64] {
            selectWordSize(app: app, "\(bits)-bit")
            XCTAssertEqual(binaryDigits(app: app).count, bits, "Binary label should have \(bits) digits")
        }
    }

    func testBinaryOnesComplementAt8Bit() throws {
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["Binary"].tap()
        selectWordSize(app: app, "8-bit")

        app.buttons["1"].tap()
        UITestHelper.ones(app: app)
        XCTAssertEqual(binaryDigits(app: app), "11111110")

        app.tabBars["Tab Bar"].buttons["Decimal"].tap()
        XCTAssert(UITestHelper.assertResult(app: app, expected: "-2", calculator: 2))
    }

    func testBinaryDigitLimitFollowsWordSize() throws {
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["Binary"].tap()
        selectWordSize(app: app, "8-bit")

        for _ in 0..<10 {
            app.buttons["1"].tap()
        }
        XCTAssertEqual(binaryDigits(app: app), "11111111")
    }

    func testWordSizeIsSharedBetweenTabs() throws {
        let app = XCUIApplication()
        selectWordSize(app: app, "16-bit")

        app.tabBars["Tab Bar"].buttons["Binary"].tap()
        XCTAssert(app.buttons["Word Size Button"].label.contains("16-bit"))
        XCTAssertEqual(binaryDigits(app: app).count, 16)

        // The Decimal tab has no word size
        app.tabBars["Tab Bar"].buttons["Decimal"].tap()
        XCTAssertFalse(app.buttons["Word Size Button"].exists)
    }

    func testOverflowStillReportedAt64Bit() throws {
        let app = XCUIApplication()
        type(app: app, "7FFFFFFFFFFFFFFF")
        UITestHelper.add(app: app)
        type(app: app, "1")
        UITestHelper.equals(app: app)
        XCTAssertEqual(hexLabel(app: app), "Error! Integer Overflow!")
    }
}
