//
//  RoundButton.swift
//  BasicCalculator
//
//  Created by Anthony Hopkins on 2020-07-13.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {

    @IBInspectable var roundButton:Bool = false {
        didSet {
            if roundButton {
                layer.cornerRadius = frame.height / 2
            }
        }
    }
    
    override func prepareForInterfaceBuilder() {
        if roundButton {
            layer.cornerRadius = frame.height / 2
        }
    }

}
