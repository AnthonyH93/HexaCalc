//
//  UIHelper.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2021-02-20.
//  Copyright © 2021 Anthony Hopkins. All rights reserved.
//

import Foundation
import UIKit

enum CalculatorLabelType {
    case large, compact
}

struct CalculatorLayout {
    let stackWidth: CGFloat
    let hStackHeight: CGFloat
    let vStackHeight: CGFloat
    let singleButtonWidth: CGFloat
    let doubleButtonWidth: CGFloat
    let labelFontSize: CGFloat
    let labelHeight: CGFloat
    let labelToStackGap: CGFloat
    let buttonFontSize: CGFloat
    let cornerRadius: CGFloat
}

class UIHelper {

    static func calculateLayout(
        width W: CGFloat,
        height H: CGFloat,
        rows nRows: Int,
        cols nCols: Int,
        labelType: CalculatorLabelType
    ) -> CalculatorLayout {
        let stackWidth = W - 20
        let colSpacing: CGFloat = 5
        let rowSpacing: CGFloat = 5

        let labelFontSize: CGFloat
        let labelHeight: CGFloat
        if labelType == .large {
            labelFontSize = min(W * 0.32, H * 0.18)
            labelHeight = labelFontSize
        } else {
            labelFontSize = min(W * 0.08, H * 0.045)
            labelHeight = labelFontSize * 2.5
        }

        let labelToStackGap: CGFloat = 23

        let usedHeight = labelHeight + labelToStackGap
        let availableH = H * 0.95 - usedHeight

        let verticalSpacing = CGFloat(nRows - 1) * rowSpacing
        let horizontalSpacing = CGFloat(nCols - 1) * colSpacing

        let btnFromWidth  = (stackWidth - horizontalSpacing) / CGFloat(nCols)
        let btnFromHeight = (availableH - verticalSpacing) / CGFloat(nRows)
        let buttonWidth   = max(btnFromWidth, 20)
        let buttonHeight  = max(btnFromHeight, 20)

        let vStackHeight = buttonHeight * CGFloat(nRows) + verticalSpacing
        let doubleButtonWidth = buttonWidth * 2 + colSpacing
        let cornerRadius = buttonHeight / 2

        let buttonFontSize = (labelType == .large ? 27.0 : 30.0) * (buttonHeight / 67.0)

        return CalculatorLayout(
            stackWidth: stackWidth,
            hStackHeight: buttonHeight,
            vStackHeight: vStackHeight,
            singleButtonWidth: buttonWidth,
            doubleButtonWidth: doubleButtonWidth,
            labelFontSize: labelFontSize,
            labelHeight: labelHeight,
            labelToStackGap: labelToStackGap,
            buttonFontSize: buttonFontSize,
            cornerRadius: cornerRadius
        )
    }
}
