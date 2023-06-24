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
    let isUnaryOperation: Bool
    
    func generateEquation() -> String {
        // Base case
        if operation == .NULL {
            return "\(leftValue) = \(result)"
        }
        // Unary operation
        else if isUnaryOperation {
            return "\(operation.rawValue) \(leftValue) = \(result)"
        }
        // Binary operation
        else {
            return "\(leftValue) \(operation.rawValue) \(rightValue) = \(result)"
        }
    }
}
