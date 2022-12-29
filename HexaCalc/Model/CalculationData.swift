//
//  CalculationData.swift
//  HexaCalc
//
//  Created by Filippo Zazzeroni on 30/09/22.
//  Copyright © 2022 Anthony Hopkins. All rights reserved.
//

import Foundation

struct CalculationData {
    let leftValue: String
    let rightValue: String
    let operation: Operation
    let result: String
    
    func generateEquation() -> String {
        // Binary operation
        if operation != .NULL {
            return "\(leftValue) \(operation.rawValue) \(rightValue) = \(result)"
        }
        // Unary operation
        else {
            return "\(leftValue) = \(result)"
        }
    }
}
