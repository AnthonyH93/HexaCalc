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
            TelemetryDeck.initialize(config: telemetryDeckConfig)
            TelemetryManager.telemetryOn = true
        }
        else {
            TelemetryManager.telemetryOn = false
        }
    }
    
    func sendSignal() {
        if TelemetryManager.telemetryOn ?? false {
            TelemetryDeck.signal("Oven.Bake.startBaking2")
        }
    }
}
