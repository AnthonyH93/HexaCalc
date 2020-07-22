//
//  StateController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2020-07-22.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import Foundation

struct convVals{
    var decimalVal:String = "0"
}

//@JA - Protocol that view controllers should have that defines that it should have a function to setState
protocol StateControllerProtocol {
  func setState(state: StateController)
}

class StateController {
    var convValues:convVals = convVals()
}
