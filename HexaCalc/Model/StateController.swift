//
//  StateController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2020-07-22.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import Foundation
import UIKit

struct convVals{
    var decimalVal: String = "0"
    var hexVal: String = "0"
    var binVal: String = "0"
    var largerThan64Bits: Bool = false
    var colour: UIColor?
    var originalTabs: [UIViewController]?
    var colourNum: Int64 = -1
    var setCalculatorTextColour: Bool = false
    var copyActionIndex: Int32 = 0
    var pasteActionIndex: Int32 = 1
    var historyButtonViewIndex: Int32 = 0
    // Acts as a binary flag (1 bit for each calculator)
    var clearLocalHistory: Int32 = 0
    var defaultTabIndex: Int32 = 3
}

protocol StateControllerProtocol {
  func setState(state: StateController)
}

class StateController {
    var convValues:convVals = convVals()
}
