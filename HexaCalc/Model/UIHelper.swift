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
    let outputLabelWidth: CGFloat
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
        labelType: CalculatorLabelType,
        targetGridHeight: CGFloat? = nil,
        isIPad: Bool = false
    ) -> CalculatorLayout {
        let naturalStackWidth = W - 20
        let colSpacing: CGFloat = 5
        let rowSpacing: CGFloat = 5

        // Label sizing for this tab
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
        let bottomPadding: CGFloat = 8
        let topLabelPadding: CGFloat = 8
        let availableH = H - labelHeight - labelToStackGap - bottomPadding - topLabelPadding

        let verticalSpacing = CGFloat(nRows - 1) * rowSpacing
        let horizontalSpacing = CGFloat(nCols - 1) * colSpacing

        let btnFromWidth  = (naturalStackWidth - horizontalSpacing) / CGFloat(nCols)
        let btnFromHeight = (availableH - verticalSpacing) / CGFloat(nRows)

        let buttonHeight: CGFloat
        let buttonWidth: CGFloat

        if isIPad {
            // iPad: fill available width and height independently, allowing rectangular buttons.
            if let target = targetGridHeight {
                buttonHeight = max((target - verticalSpacing) / CGFloat(nRows), 20)
                buttonWidth  = max(btnFromWidth, 20)
            } else {
                buttonHeight = max(btnFromHeight, 20)
                buttonWidth  = max(btnFromWidth, 20)
            }
        } else {
            // iPhone: square buttons sized by the tighter dimension.
            if let target = targetGridHeight {
                buttonHeight = max((target - verticalSpacing) / CGFloat(nRows), 20)
                buttonWidth  = max(min(btnFromWidth, buttonHeight), 20)
            } else {
                let size = max(min(btnFromWidth, btnFromHeight), 20)
                buttonHeight = size
                buttonWidth  = size
            }
        }

        let vStackHeight = buttonHeight * CGFloat(nRows) + verticalSpacing
        let stackWidth = buttonWidth * CGFloat(nCols) + colSpacing * CGFloat(nCols - 1)
        let doubleButtonWidth = buttonWidth * 2 + colSpacing
        // Use min(w,h)/2 so square buttons stay circular and rectangular buttons get pill corners.
        let cornerRadius = min(buttonWidth, buttonHeight) / 2

        // Fixed base (independent of labelType) so button text is the same size
        // across tabs for a given button size — previously Binary (.compact, 30pt
        // base) rendered noticeably larger text than Hex/Decimal (.large, 27pt base)
        // even when their buttons were the same size.
        let buttonFontSize = 27.0 * (min(buttonWidth, buttonHeight) / 67.0)

        // On iPad the history button sits in the top-right corner (44pt wide, 16pt from safe
        // trailing, 8pt gap). The label is centered in the view, so its right edge =
        // W/2 + labelWidth/2. To clear the button: labelWidth = W - 2*safeRight - 136.
        // We approximate safeRight ≈ 0 and use W - 136, capped at stackWidth.
        let outputLabelWidth = isIPad ? min(stackWidth, W - 136) : stackWidth

        return CalculatorLayout(
            stackWidth: stackWidth,
            outputLabelWidth: outputLabelWidth,
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
