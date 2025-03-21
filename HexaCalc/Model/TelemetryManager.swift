//
//  Telemetry.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2025-03-18.
//  Copyright © 2025 Anthony Hopkins. All rights reserved.
//

import Foundation
import TelemetryDeck

// Utility class for sending signals to TelemetryDeck
class TelemetryManager {
    
    // Singleton instance of this class
    static let sharedTelemetryManager = TelemetryManager()
    
    // Toggle for collecting telemetry data
    private static var telemetryOn: Bool?
    
    // Structure for initializing the TelemetryManager
    struct TelemetryManagerConfig {
        let appID: String
    }
    
    private static var config: TelemetryManagerConfig?
    
    class func setup(_ config: TelemetryManagerConfig) {
        TelemetryManager.config = config
    }
    
    private init(){
        // Choose mode based on whether configuration is complete
        if let config = TelemetryManager.config {
            let telemetryDeckConfig = TelemetryDeck.Config(appID: config.appID)
            telemetryDeckConfig.defaultSignalPrefix = "HexaCalc"
            TelemetryDeck.initialize(config: telemetryDeckConfig)
            TelemetryManager.telemetryOn = true
        }
        else {
            TelemetryManager.telemetryOn = false
        }
    }
    
    func sendCalculatorSignal(tab: TelemetryTab, action: TelemetryCalculatorAction) {
        if TelemetryManager.telemetryOn ?? false {
            TelemetryDeck.signal(".\(tab).\(action)")
        }
    }
    
    func sendSettingsSignal(section: TelemetrySettingsSection, action: TelemetrySettingsAction, parameters: [String : String]? = nil) {
        if TelemetryManager.telemetryOn ?? false {
            if let params = parameters {
                TelemetryDeck.signal(
                    ".\(TelemetryTab.Settings).\(section).\(action)",
                    parameters: params
                )
            }
            else {
                TelemetryDeck.signal(".\(TelemetryTab.Settings).\(section).\(action)")
            }
        }
    }
}

// Enums to control types of signals
enum TelemetryTab: String {
    case Hexadecimal = "Hexadecimal"
    case Binary = "Binary"
    case Decimal = "Decimal"
    case Settings = "Settings"
    case History = "History"
}

enum TelemetryCalculatorAction: String {
    // Calculator actions
    case Equals = "equalsPressed"
    case Second = "2ndPressed"
    case Copy = "valueCopied"
    case Paste = "valuePasted"
    case CopyAndPaste = "copyAndPastePopupShown"
    case Overflow = "integerOverflow"
    case DeleteSwipe = "swipedToDelete"
    case Appeared = "appeared"
}

enum TelemetrySettingsSection: String {
    case TabBar = "TabBar"
    case Gestures = "Gestures"
    case Customization = "Customization"
    case History = "CalculationHistory"
    case About = "AboutTheApp"
    case Support = "Support"
}

enum TelemetrySettingsAction: String {
    // TabBar actions
    case Hexadecimal = "hexadecimalSwitchPressed"
    case Binary = "binarySwitchPressed"
    case Decimal = "decimalSwitchPressed"
    case DefaultTab = "defaultSelectedTabChanged"
    // Gestures actions
    case Copy = "copyActionChanged"
    case Paste = "pasteActionChanged"
    // Customization actions
    case Colour = "colourChanged"
    case TextColour = "setCalculatorTextColourSwitchPressed"
    // Calculation history actions
    case History = "historyButtonViewChanged"
    case ClearHistory = "clearLocalHistory"
    // About the app actions
    case OpenSource = "openSourcePressed"
    case Share = "sharePressed"
    case Review = "reviewPressed"
    // Support actions
    case Email = "emailFeedbackPressed"
}
