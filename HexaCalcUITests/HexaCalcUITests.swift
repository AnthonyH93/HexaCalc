//
//  HexaCalcUITests.swift
//  HexaCalcUITests
//
//  Created by Anthony Hopkins on 2022-09-24.
//  Copyright © 2022 Anthony Hopkins. All rights reserved.
//

import XCTest

class HexaCalcUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        XCUIApplication().buttons["hexadecimalOutputLabel"].tap()
//        let text = app.staticTexts.element(matching: .any, identifier: "hexadecimalOutputLabel").label
        
        let button = XCUIApplication().buttons["A"]
        button.tap()
        button.tap()
        
//        let text = app.staticTexts["hexadecimalOutputLabel"].element.label
                
        XCTAssert(app.staticTexts["AA"].label == "AA")
        
//        let app = XCUIApplication()
//        app.alerts["Paste from Clipboard"].scrollViews.otherElements.buttons["Cancel"].tap()
//
//        let hexadecimaloutputlabelStaticText = app.staticTexts["hexadecimalOutputLabel"]
//        hexadecimaloutputlabelStaticText.tap()
//        hexadecimaloutputlabelStaticText.tap()
        //        XCTAssert(text == "0")
    }
}
