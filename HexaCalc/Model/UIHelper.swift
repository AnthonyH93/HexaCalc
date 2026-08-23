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
    let topPadding: CGFloat
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
        } else if isIPad {
            // iPad: Binary's text is now always exactly two lines of 32 bits each
            // (see formatBinaryString), so the font can be sized to actually fill
            // the label's width instead of the fixed ratio below, which was tuned
            // for iPhone's much narrower screen and left iPad's text tiny.
            let approxLabelWidth = max(W - 136, 20)
            let sampleLine = "0000 0000 0000 0000 0000 0000 0000 0000"
            let font = UIFont(name: "Avenir Next", size: 100) ?? UIFont.systemFont(ofSize: 100)
            let measuredWidth = (sampleLine as NSString).size(withAttributes: [.font: font]).width
            let widthFitSize = measuredWidth > 0 ? (approxLabelWidth * 0.97) / measuredWidth * 100 : 44
            labelFontSize = min(widthFitSize, H * 0.14)
            labelHeight = labelFontSize * 2.5
        } else {
            labelFontSize = min(W * 0.08, H * 0.045)
            labelHeight = labelFontSize * 2.5
        }

        let labelToStackGap: CGFloat = 23
        let bottomPadding: CGFloat = 8
        // Reserve enough room above the label so it clears the top-pinned history
        // button (see HistoryButtonHost.repositionHistoryButton) instead of the grid
        // simply filling all the way up to a flat 8pt floor. On iPad, and on iPhone in
        // landscape or on short portrait screens (SE, 8, 7/8 Plus), the button sits
        // right under the safe area (offset 8 on iPad/landscape, 4 on short portrait)
        // — without this, a tall grid could push the label's fixed-height frame up
        // underneath the button. Tall iPhone portraits pin the button well below the
        // label already (view.topAnchor + 60), so the flat floor is left as-is there.
        let topLabelPadding: CGFloat
        if isIPad {
            topLabelPadding = 56
        } else {
            let isLandscape = W > H
            if isLandscape || H <= 736 {
                let historyButtonTopOffset: CGFloat = isLandscape ? 8 : 4
                let historyButtonHeight: CGFloat = 44
                let gap: CGFloat = 8
                topLabelPadding = historyButtonTopOffset + historyButtonHeight + gap
            } else {
                topLabelPadding = 8
            }
        }
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
            cornerRadius: cornerRadius,
            topPadding: topLabelPadding
        )
    }

    // On iPad, Binary/Decimal/Hex are forced to share one grid height so the button
    // grids match, but each tab's own label height differs, so the leftover slack
    // between the (label + gap + grid) block and the safe area varies per tab. Hex
    // and Decimal size their own label with the same formula used to compute the
    // shared grid height, so their content always fills the safe area exactly (zero
    // slack) — the grid sits flush against bottomPadding regardless of this function.
    // Binary's label uses a different (shorter, in tall/narrow windows) formula, so
    // it alone can end up with real slack. Giving that slack to the bottom would
    // pull Binary's grid away from the tab bar while Hex/Decimal's stays flush,
    // visibly inconsistent between tabs — so all of it goes above the label instead,
    // keeping the grid's bottom edge aligned with the other two tabs. iPhone is
    // untouched — it always returns the original fixed padding.
    static func verticalOffsets(safeHeight: CGFloat, layout: CalculatorLayout, isIPad: Bool) -> (top: CGFloat, bottom: CGFloat) {
        let bottomPadding: CGFloat = 8
        guard isIPad else { return (layout.topPadding, bottomPadding) }

        let contentHeight = layout.labelHeight + layout.labelToStackGap + layout.vStackHeight
        let slack = max(safeHeight - contentHeight - layout.topPadding - bottomPadding, 0)
        return (layout.topPadding + slack, bottomPadding)
    }
}
