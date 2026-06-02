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

    // Set to true at launch via HexaCalcTabBarController when the user preference is on.
    static var liquidGlassEnabled = false

    @IBInspectable var roundButton: Bool = false {
        didSet {
            if roundButton {
                layer.cornerRadius = frame.height / 2
            }
        }
    }

    // MARK: - Liquid glass layers

    private var glassSpecularLayer: CAGradientLayer?
    private var glassBorderLayer: CALayer?

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        guard layer.cornerRadius > 0 else { return }
        if Self.liquidGlassEnabled {
            applyLiquidGlass()
        } else {
            removeLiquidGlass()
        }
    }

    // MARK: - Glass effect

    private func applyLiquidGlass() {
        let radius = layer.cornerRadius

        if glassSpecularLayer == nil {
            let specular = CAGradientLayer()
            specular.startPoint = CGPoint(x: 0.5, y: 0.0)
            specular.endPoint = CGPoint(x: 0.5, y: 1.0)
            layer.insertSublayer(specular, at: 0)
            glassSpecularLayer = specular
        }
        if glassBorderLayer == nil {
            let border = CALayer()
            border.masksToBounds = true
            layer.addSublayer(border)
            glassBorderLayer = border
        }

        glassSpecularLayer?.frame = bounds
        glassSpecularLayer?.cornerRadius = radius
        glassSpecularLayer?.masksToBounds = true
        glassSpecularLayer?.colors = [
            UIColor.white.withAlphaComponent(0.42).cgColor,
            UIColor.white.withAlphaComponent(0.15).cgColor,
            UIColor.white.withAlphaComponent(0.0).cgColor,
        ]
        glassSpecularLayer?.locations = [0.0, 0.38, 0.65]

        glassBorderLayer?.frame = bounds
        glassBorderLayer?.cornerRadius = radius
        glassBorderLayer?.borderWidth = 1.0
        glassBorderLayer?.borderColor = UIColor.white.withAlphaComponent(0.30).cgColor

        // Shadow requires masksToBounds = false; corner rounding on the layer itself still works.
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.28
        layer.shadowRadius = 4.0
        layer.shadowOffset = CGSize(width: 0, height: 3)
    }

    private func removeLiquidGlass() {
        guard glassSpecularLayer != nil || glassBorderLayer != nil else { return }
        glassSpecularLayer?.removeFromSuperlayer()
        glassSpecularLayer = nil
        glassBorderLayer?.removeFromSuperlayer()
        glassBorderLayer = nil
        layer.shadowOpacity = 0
    }

    override func prepareForInterfaceBuilder() {
        if roundButton {
            layer.cornerRadius = frame.height / 2
        }
    }
}
