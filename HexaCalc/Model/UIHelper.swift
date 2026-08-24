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
    let binaryLineCount: Int
}

class UIHelper {

    // The label's available width on iPad: clears the top-right history button (fixed
    // 136pt clearance, negligible on a full-size iPad but a large fraction of a narrow
    // resized window) without ever shrinking below 80% of the grid's own width
    // (naturalStackWidth == the eventual stackWidth exactly, since the per-button width
    // division has no remainder — see calculateLayout). Used both to size the label's
    // actual width constraint and to fit Binary's compact-label font to that same width,
    // so the two can never drift apart the way they did when the font fit a stale,
    // narrower estimate while the box itself had already widened.
    private static func iPadLabelWidthBudget(width W: CGFloat) -> CGFloat {
        let stackWidth = W - 20
        let cappedByHistoryButton = W - 136
        let minLabelWidth = stackWidth * 0.80
        return max(min(stackWidth, cappedByHistoryButton), minLabelWidth)
    }

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
        let binaryLineCount: Int
        if labelType == .large {
            labelFontSize = min(W * 0.32, H * 0.18)
            labelHeight = labelFontSize
            binaryLineCount = 2
        } else if isIPad {
            // iPad: Binary's 64-bit string is grouped into 4-bit nibbles ("0000") and
            // can be split across more lines than the usual 2 (32 bits each) to fit
            // narrow windows — halving the characters on a line roughly doubles the
            // font size that still fits the available width. Stick with 2 lines as
            // long as that stays legible; only split further once 2 lines would render
            // below a readable size. Full-size iPads never come close to that floor
            // (measured 29-40+pt even at 2 lines there), so their layout — and the
            // traditional 2-line look — is completely unaffected; this only kicks in
            // on windows narrow enough that 2 lines alone can't stay legible (e.g. an
            // iPhone-width resized "Designed for iPad" window).
            let approxLabelWidth = max(iPadLabelWidthBudget(width: W), 20)
            let font = UIFont(name: "Avenir Next", size: 100) ?? UIFont.systemFont(ofSize: 100)
            let totalNibbles = 16
            let minLegibleFontSize: CGFloat = 20
            let lineCountCandidates = [2, 4, 8]
            var candidateLineCount = lineCountCandidates.last!
            var candidateFontSize: CGFloat = 44
            for lineCount in lineCountCandidates {
                let nibblesPerLine = totalNibbles / lineCount
                let sampleLine = Array(repeating: "0000", count: nibblesPerLine).joined(separator: " ")
                let measuredWidth = (sampleLine as NSString).size(withAttributes: [.font: font]).width
                let widthFitSize = measuredWidth > 0 ? (approxLabelWidth * 0.97) / measuredWidth * 100 : 44
                candidateFontSize = min(widthFitSize, H * 0.14)
                candidateLineCount = lineCount
                if candidateFontSize >= minLegibleFontSize {
                    break
                }
            }
            labelFontSize = candidateFontSize
            labelHeight = labelFontSize * 1.25 * CGFloat(candidateLineCount)
            binaryLineCount = candidateLineCount
        } else {
            labelFontSize = min(W * 0.08, H * 0.045)
            labelHeight = labelFontSize * 2.5
            binaryLineCount = 2
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
            // iPad: fill available width and height independently, allowing rectangular
            // buttons. Landscape windows naturally produce much wider-than-tall buttons
            // (measured as low as ~0.4 height:width on a full-screen 13" iPad landscape)
            // — that's normal and must stay unconstrained. But height stretching far past
            // width is pathological: it's never seen in full-screen portrait or landscape
            // (measured up to ~0.88 there), only in narrow/tall resized windows, and it's
            // what makes buttons look like tall pills with tiny text (font size below
            // tracks the smaller dimension). Cap only that one direction, with real
            // headroom above the measured full-screen ceiling so no real device is affected.
            let rawHeight: CGFloat
            if let target = targetGridHeight {
                rawHeight = max((target - verticalSpacing) / CGFloat(nRows), 20)
            } else {
                rawHeight = max(btnFromHeight, 20)
            }
            let rawWidth = max(btnFromWidth, 20)
            let maxHeightOverWidth: CGFloat = 1.3
            buttonWidth = rawWidth
            buttonHeight = min(rawHeight, rawWidth * maxHeightOverWidth)
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

        // Hex/Decimal's right-aligned text should sit flush with the grid's true right
        // edge (matching the button column above it), so their label always gets the
        // full stackWidth — their font (the .large formula above) doesn't depend on
        // label width at all, so widening the box is purely cosmetic here, no sizing
        // side effects. Binary's compact-iPad font, by contrast, is fit directly to
        // iPadLabelWidthBudget (see above) to choose its line count/font size, so its
        // box width must keep matching that same budget or the two drift apart again.
        let outputLabelWidth = (isIPad && labelType == .compact) ? iPadLabelWidthBudget(width: W) : stackWidth

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
            topPadding: topLabelPadding,
            binaryLineCount: binaryLineCount
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
