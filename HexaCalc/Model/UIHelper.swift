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
    static func setupStackConstraints(hStacks: [UIStackView], vStack: UIStackView, screenWidth: CGFloat) -> [NSLayoutConstraint] {
        
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
                if (screenWidth == 320) {
                    tripleButton!.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
                }
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
    
    // Setup calculator label constraints
    static func setupLabelConstraints(label: UILabel, screenWidth: CGFloat, calculator: Int) -> [NSLayoutConstraint] {
        
        let labelWidth = screenWidth - 20
        let labelHeight: CGFloat = 64
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(label.widthAnchor.constraint(equalToConstant: labelWidth))
        constraints.append(label.heightAnchor.constraint(equalToConstant: labelHeight))
        
        //Adjust binary label font size
        if (calculator == 2) {
            if (screenWidth == 320) {
                label.font = UIFont(name: "Avenir Next", size: 14.5)
            }
        }
        else {
            if (screenWidth == 320) {
                label.font = UIFont(name: "Avenir Next", size: 50)
            }
        }
        
        return constraints
    }
    
    // Setup calculator stack constraints for iPad
    static func iPadSetupStackConstraints(hStacks: [UIStackView], vStack: UIStackView, screenWidth: CGFloat, screenHeight: CGFloat) -> [NSLayoutConstraint] {
        
        let stackWidth = screenWidth - 20
        let vStackHeight = screenHeight/1.5
        var hStackHeight: CGFloat = 0
    
        var constraints = [NSLayoutConstraint]()
        
        // Hexadecimal calculator
        if (hStacks.count == 6) {
            hStackHeight = (vStackHeight - 25)/6
        }
        // Binary or Decimal calculator
        else {
            hStackHeight = (vStackHeight - 20)/5
        }
        
        for hStack in hStacks {
            constraints.append(hStack.widthAnchor.constraint(equalToConstant: stackWidth))
            constraints.append(hStack.heightAnchor.constraint(equalToConstant: hStackHeight))
        }
        
        constraints.append(vStack.widthAnchor.constraint(equalToConstant: stackWidth))
        constraints.append(vStack.heightAnchor.constraint(equalToConstant: vStackHeight))
        
        return constraints
    }
    
    // Setup calculator button constraints for iPad
    static func iPadSetupButtonConstraints(singleButtons: [RoundButton], doubleButtons: [RoundButton], tripleButton: RoundButton?, screenWidth: CGFloat, screenHeight: CGFloat, calculator: Int) -> [NSLayoutConstraint] {
        
        let stackWidth = screenWidth - 20
        let vStackHeight = screenHeight/1.5
        var buttonHeight: CGFloat = 0
        var singleButtonWidth: CGFloat = 0
        var doubleButtonWidth: CGFloat = 0
        var buttonFontSize: CGFloat = 0
        
        var constraints = [NSLayoutConstraint]()
        
        // Decide button text size
        switch screenWidth {
        case 0..<800:
            buttonFontSize = 50
        case 800..<1000:
            buttonFontSize = 55
        default:
            buttonFontSize = 60
        }
        
        // Hexadecimal
        if (calculator == 1) {
            buttonHeight = (vStackHeight - 25)/6
            singleButtonWidth = (stackWidth - 40)/5.0
            doubleButtonWidth = (singleButtonWidth * 2) + 10
            let tripleButtonWidth: CGFloat = (singleButtonWidth * 3) + 20
            
            if (tripleButton != nil) {
                constraints.append(tripleButton!.widthAnchor.constraint(equalToConstant: tripleButtonWidth))
                constraints.append(tripleButton!.heightAnchor.constraint(equalToConstant: buttonHeight))
                tripleButton!.layer.cornerRadius = buttonHeight/2
                tripleButton!.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize, weight: .semibold)
            }
            
        }
        // Binary or Decimal
        else {
            buttonHeight = (vStackHeight - 20)/5
            singleButtonWidth = (stackWidth - 30)/4.0
            doubleButtonWidth = (singleButtonWidth * 2) + 10
        }
        
        for button in singleButtons {
            constraints.append(button.widthAnchor.constraint(equalToConstant: singleButtonWidth))
            constraints.append(button.heightAnchor.constraint(equalToConstant: buttonHeight))
            button.layer.cornerRadius = buttonHeight/2
            button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize, weight: .semibold)
        }
        
        for button in doubleButtons {
            constraints.append(button.widthAnchor.constraint(equalToConstant: doubleButtonWidth))
            constraints.append(button.heightAnchor.constraint(equalToConstant: buttonHeight))
            button.layer.cornerRadius = buttonHeight/2
            button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize, weight: .semibold)
        }
        
        return constraints
    }
    
    // Setup calculator label constraints for iPads
    static func iPadSetupLabelConstraints(label: UILabel, screenWidth: CGFloat, calculator: Int) -> [NSLayoutConstraint] {
        
        let labelWidth = screenWidth - 20
        let labelHeight: CGFloat = 150
        var labelFontSize: CGFloat = 0
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(label.widthAnchor.constraint(equalToConstant: labelWidth))
        constraints.append(label.heightAnchor.constraint(equalToConstant: labelHeight))
        
        //Adjust label font sizes
        if (calculator == 2) {
            switch screenWidth {
            case 0..<800:
                labelFontSize = 40
            case 800..<1000:
                labelFontSize = 50
            default:
                labelFontSize = 60
            }
        }
        else {
            switch screenWidth {
            case 0..<800:
                labelFontSize = 130
            case 800..<1000:
                labelFontSize = 140
            default:
                labelFontSize = 160
            }
        }
        
        label.font = UIFont(name: "Avenir Next", size: labelFontSize)
        
        return constraints
    }
}
