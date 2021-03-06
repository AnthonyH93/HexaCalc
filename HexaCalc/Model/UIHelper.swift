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
        var buttonFontSize: CGFloat = 0
        
        var constraints = [NSLayoutConstraint]()
        
        // Hexadecimal
        if (calculator == 1) {
            singleButtonSize = (stackWidth - 40)/5.0
            doubleButtonSize = (singleButtonSize * 2) + 10
            let tripleButtonSize: CGFloat = (singleButtonSize * 3) + 20
            
            // Scale button font size based on screen width
            buttonFontSize = 27*(screenWidth/375)
            
            if (tripleButton != nil) {
                constraints.append(tripleButton!.widthAnchor.constraint(equalToConstant: tripleButtonSize))
                constraints.append(tripleButton!.heightAnchor.constraint(equalToConstant: singleButtonSize))
                tripleButton!.layer.cornerRadius = singleButtonSize/2
                tripleButton!.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize, weight: .semibold)
            }
            
        }
        // Binary or Decimal
        else {
            // Scale button font size based on screen width
            buttonFontSize = 30*(screenWidth/375)
            singleButtonSize = (stackWidth - 30)/4.0
            doubleButtonSize = (singleButtonSize * 2) + 10
        }
        
        for button in singleButtons {
            constraints.append(button.widthAnchor.constraint(equalToConstant: singleButtonSize))
            constraints.append(button.heightAnchor.constraint(equalToConstant: singleButtonSize))
            button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize, weight: .semibold)
            button.layer.cornerRadius = singleButtonSize/2
        }
        
        for button in doubleButtons {
            constraints.append(button.widthAnchor.constraint(equalToConstant: doubleButtonSize))
            constraints.append(button.heightAnchor.constraint(equalToConstant: singleButtonSize))
            button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize, weight: .semibold)
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
        var constraints = [NSLayoutConstraint]()
        
        // Use iPhone constraints if screen width is of that size
        if (screenWidth < 415) {
            constraints = setupStackConstraints(hStacks: hStacks, vStack: vStack, screenWidth: screenWidth)
        }
        else {
            let stackWidth = screenWidth - 20
            var vStackHeight = ((screenWidth * 2) > screenHeight) ? screenHeight/1.5 : screenHeight/1.75
            var hStackHeight: CGFloat = 0
            
            // Vertical slide over needs special consideration
            if ((screenWidth * 3) < screenHeight) {
                vStackHeight = screenHeight/2.5
            }
            
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
        }
        return constraints
    }
    
    // Setup calculator button constraints for iPad
    static func iPadSetupButtonConstraints(singleButtons: [RoundButton], doubleButtons: [RoundButton], tripleButton: RoundButton?, screenWidth: CGFloat, screenHeight: CGFloat, calculator: Int) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        // Use iPhone constraints if screen width is of that size
        if (screenWidth < 415) {
            constraints = setupButtonConstraints(singleButtons: singleButtons, doubleButtons: doubleButtons, tripleButton: tripleButton, screenWidth: screenWidth, calculator: calculator)
        }
        else {
            let stackWidth = screenWidth - 20
            var vStackHeight = ((screenWidth * 2) > screenHeight) ? screenHeight/1.5 : screenHeight/1.75
            var buttonHeight: CGFloat = 0
            var singleButtonWidth: CGFloat = 0
            var doubleButtonWidth: CGFloat = 0
            var buttonFontSize: CGFloat = 0
            
            // Vertical slide over needs special consideration
            if ((screenWidth * 3) < screenHeight) {
                vStackHeight = screenHeight/2.5
            }
            
            // Hexadecimal
            if (calculator == 1) {
                buttonHeight = (vStackHeight - 25)/6
                singleButtonWidth = (stackWidth - 40)/5.0
                doubleButtonWidth = (singleButtonWidth * 2) + 10
                let tripleButtonWidth: CGFloat = (singleButtonWidth * 3) + 20
                
                // Scale button font size based on screen width
                buttonFontSize = 27*(min(screenHeight, screenWidth)/375)
                
                if (tripleButton != nil) {
                    constraints.append(tripleButton!.widthAnchor.constraint(equalToConstant: tripleButtonWidth))
                    constraints.append(tripleButton!.heightAnchor.constraint(equalToConstant: buttonHeight))
                    tripleButton!.layer.cornerRadius = ((screenWidth * 2) > screenHeight) ? buttonHeight/2 : buttonHeight/3
                    tripleButton!.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize, weight: .semibold)
                }
                
            }
            // Binary or Decimal
            else {
                buttonHeight = (vStackHeight - 20)/5
                singleButtonWidth = (stackWidth - 30)/4.0
                doubleButtonWidth = (singleButtonWidth * 2) + 10
                
                // Scale button font size based on screen width
                buttonFontSize = 30*(min(screenHeight, screenWidth)/375)
            }
            
            for button in singleButtons {
                constraints.append(button.widthAnchor.constraint(equalToConstant: singleButtonWidth))
                constraints.append(button.heightAnchor.constraint(equalToConstant: buttonHeight))
                button.layer.cornerRadius = ((screenWidth * 2) > screenHeight) ? buttonHeight/2 : buttonHeight/3
                button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize, weight: .semibold)
            }
            
            for button in doubleButtons {
                constraints.append(button.widthAnchor.constraint(equalToConstant: doubleButtonWidth))
                constraints.append(button.heightAnchor.constraint(equalToConstant: buttonHeight))
                button.layer.cornerRadius = ((screenWidth * 2) > screenHeight) ? buttonHeight/2 : buttonHeight/3
                button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize, weight: .semibold)
            }
        }
        
        return constraints
    }
    
    // Setup calculator label constraints for iPads
    static func iPadSetupLabelConstraints(label: UILabel, screenWidth: CGFloat, calculator: Int) -> [NSLayoutConstraint] {
        let labelWidth = screenWidth - 20
        var labelHeight: CGFloat = 0
        var labelFontSize: CGFloat = 0
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(label.widthAnchor.constraint(equalToConstant: labelWidth))
        
        //Adjust label font sizes
        if (calculator == 2) {
            switch screenWidth {
            case 0..<330:
                labelFontSize = 18
            case 330..<400:
                labelFontSize = 20
            case 400..<600:
                labelFontSize = 35
            case 600..<825:
                labelFontSize = 45
            case 825..<1025:
                labelFontSize = 50
            default:
                labelFontSize = 70
            }
            labelHeight = (labelFontSize * 2.5)
        }
        else {
            switch screenWidth {
            case 0..<330:
                labelFontSize = 65
            case 330..<400:
                labelFontSize = 75
            case 400..<600:
                labelFontSize = 110
            case 600..<800:
                labelFontSize = 120
            case 800..<900:
                labelFontSize = 130
            case 900..<1000:
                labelFontSize = 140
            default:
                labelFontSize = 160
            }
            labelHeight = labelFontSize
        }
        
        constraints.append(label.heightAnchor.constraint(equalToConstant: labelHeight))
        
        label.font = UIFont(name: "Avenir Next", size: labelFontSize)
        
        return constraints
    }
}
