//
//  UIHelper.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2021-02-20.
//  Copyright © 2021 Anthony Hopkins. All rights reserved.
//

import Foundation
import UIKit

// Class of static helper functions for setting up the UI
class UIHelper {
    
    // Setup calculator stack constraints
    static func setupStackContraints(hStacks: [UIStackView], vStack: UIStackView, screenWidth: CGFloat) -> [NSLayoutConstraint] {
        
        let stackWidth = screenWidth - 20
        var hStackHeight: CGFloat = 0
        var vStackHeight: CGFloat = 0
    
        var constraints = [NSLayoutConstraint]()
        
        // Hexadecimal calculator
        if (hStacks.count == 6) {
            hStackHeight = (stackWidth - 40)/5.0
            vStackHeight = (hStackHeight * 6) + 25
        }
        // Binary or Decimal calculator
        else {
            hStackHeight = (stackWidth - 30)/4.0
            vStackHeight = (hStackHeight * 5) + 20
        }
        
        for hStack in hStacks {
            constraints.append(hStack.widthAnchor.constraint(equalToConstant: stackWidth))
            constraints.append(hStack.heightAnchor.constraint(equalToConstant: hStackHeight))
        }
        
        constraints.append(vStack.widthAnchor.constraint(equalToConstant: stackWidth))
        constraints.append(vStack.heightAnchor.constraint(equalToConstant: vStackHeight))
        
        return constraints
    }
    
    // Setup calculator button constraints
    static func setupButtonConstraints(singleButtons: [RoundButton], doubleButtons: [RoundButton], tripleButton: RoundButton?, screenWidth: CGFloat, calculator: Int) -> [NSLayoutConstraint] {
        
        let stackWidth = screenWidth - 20
        var singleButtonSize: CGFloat = 0
        var doubleButtonSize: CGFloat = 0
        
        var constraints = [NSLayoutConstraint]()
        
        // Hexadecimal
        if (calculator == 1) {
            singleButtonSize = (stackWidth - 40)/5.0
            doubleButtonSize = (singleButtonSize * 2) + 10
            let tripleButtonSize: CGFloat = (singleButtonSize * 3) + 20
            
            if (tripleButton != nil) {
                constraints.append(tripleButton!.widthAnchor.constraint(equalToConstant: tripleButtonSize))
                constraints.append(tripleButton!.heightAnchor.constraint(equalToConstant: singleButtonSize))
                tripleButton!.layer.cornerRadius = singleButtonSize/2
            }
            
        }
        // Binary or Decimal
        else {
            singleButtonSize = (stackWidth - 30)/4.0
            doubleButtonSize = (singleButtonSize * 2) + 10
        }
        
        for button in singleButtons {
            constraints.append(button.widthAnchor.constraint(equalToConstant: singleButtonSize))
            constraints.append(button.heightAnchor.constraint(equalToConstant: singleButtonSize))
            if (screenWidth == 320) {
                button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
            }
            button.layer.cornerRadius = singleButtonSize/2
        }
        
        for button in doubleButtons {
            constraints.append(button.widthAnchor.constraint(equalToConstant: doubleButtonSize))
            constraints.append(button.heightAnchor.constraint(equalToConstant: singleButtonSize))
            if (screenWidth == 320) {
                button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
            }
            button.layer.cornerRadius = singleButtonSize/2
        }
        
        return constraints
    }
    
    static func setupLabelConstraints(label: UILabel, screenWidth: CGFloat) -> [NSLayoutConstraint] {
        
        let labelWidth = screenWidth - 20
        let labelHeight: CGFloat = 64
        
        var constraints = [NSLayoutConstraint]()
        
        if (screenWidth == 320) {
            label.font = UIFont(name: "Avenir Next", size: 50)
        }
        
        constraints.append(label.widthAnchor.constraint(equalToConstant: labelWidth))
        constraints.append(label.heightAnchor.constraint(equalToConstant: labelHeight))
        
        return constraints
    }
}
