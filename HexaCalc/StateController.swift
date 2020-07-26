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
    var hexVal:String = "0"
    var binVal:String = "0"
    var largerThan64Bits:Bool = false
    var signedMode:Bool = false
}

protocol StateControllerProtocol {
  func setState(state: StateController)
}

class StateController {
    var convValues:convVals = convVals()
}
