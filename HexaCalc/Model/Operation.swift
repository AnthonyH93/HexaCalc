//
//  Operation.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2022-09-22.
//  Copyright © 2022 Anthony Hopkins. All rights reserved.
//

import Foundation

// Used by all calculators
// Defines set of possible operations
enum Operation: String {
    case Add = "+"
    case Subtract = "-"
    case Divide = "/"
    case Multiply = "*"
    case Modulus = "%"
    case Exp = "EXP"
    case AND = "&"
    case OR = "|"
    case XOR = "^"
    case LeftShift = "<<"
    case RightShift = ">>"
    case NULL = "Empty"
}
