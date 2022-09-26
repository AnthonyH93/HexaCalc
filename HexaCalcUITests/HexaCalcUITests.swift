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

    func testBasicAppSetup() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Launched on Hexadecimal tab
        
        app.buttons["A"].tap()
        app.buttons["B"].tap()
                
        XCTAssert(app.staticTexts["AB"].label == "AB")
        
        let tabBar = app.tabBars["Tab Bar"]
        
        tabBar.buttons["Binary"].tap()
                
        XCTAssert(app.buttons["0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 1010 1011"].label == "0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 1010 1011")
        
        app/*@START_MENU_TOKEN@*/.staticTexts["1"]/*[[".buttons[\"1\"].staticTexts[\"1\"]",".staticTexts[\"1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        tabBar.buttons["Decimal"].tap()
        
        XCTAssert(app.buttons["343"].label == "343")
        
        app.buttons["9"].tap()
        
        tabBar.buttons["Settings"].tap()
        
        // App rating popup might appear
        if (app.scrollViews.otherElements.buttons["Not Now"].exists) {
            app.scrollViews.otherElements.buttons["Not Now"].tap()
        }
        
        tabBar.buttons["Hexadecimal"].tap()
        
        XCTAssert(app.staticTexts["D6F"].label == "D6F")
    }
    
    func testHexadecimalBasicCalculations() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let acButton = app.buttons["AC"]
        let divButton = app.buttons["÷"]
        let multButton = app.buttons["×"]
        let subButton = app.buttons["-"]
        let plusButton = app.buttons["+"]
        let equalsButton = app.buttons["="]
        
        app.buttons["1"].tap()
        app.buttons["0"].tap()
        
        XCTAssert(app.staticTexts["10"].label == "10")
        
        // Addition
        plusButton.tap()
        
        app.buttons["3"].tap()
        app.buttons["2"].tap()
        
        XCTAssert(app.staticTexts["32"].label == "32")
        
        equalsButton.tap()
        
        XCTAssert(app.staticTexts["42"].label == "42")
        
        // Subtraction
        subButton.tap()
        
        app.buttons["3"].tap()
        app.buttons["0"].tap()
        
        XCTAssert(app.staticTexts["30"].label == "30")
        
        equalsButton.tap()
        
        XCTAssert(app.staticTexts["12"].label == "12")
        
        // Multiplication
        multButton.tap()
        
        app.buttons["F"].tap()
        app.buttons["E"].tap()
        
        XCTAssert(app.staticTexts["FE"].label == "FE")
        
        equalsButton.tap()
        
        XCTAssert(app.staticTexts["11DC"].label == "11DC")
        
        // Division
        divButton.tap()
        
        app.buttons["A"].tap()
        app.buttons["B"].tap()
        
        XCTAssert(app.staticTexts["AB"].label == "AB")
        
        equalsButton.tap()
        
        XCTAssert(app.staticTexts["1A"].label == "1A")
        
        acButton.tap()
                
        XCTAssert(!app.staticTexts["1A"].exists)
    }
}
