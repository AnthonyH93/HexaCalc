//
//  HistoryButtonHost.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2026-04-16.
//  Copyright © 2026 Anthony Hopkins. All rights reserved.
//

import UIKit

@objc protocol HistoryButtonHost: AnyObject {
    var historyButton: UIButton! { get set }
    var historyButtonWidthConstraint: NSLayoutConstraint? { get set }
    func historyButtonTapped()
}

extension HistoryButtonHost where Self: UIViewController {

    func setupHistoryButton() {
        if historyButton?.superview != nil {
            return
        }
        
        historyButton = UIButton(type: .system)
        historyButton.translatesAutoresizingMaskIntoConstraints = false
        historyButton.layer.cornerRadius = 22
        historyButton.clipsToBounds = true
        
        view.addSubview(historyButton)

        let widthConstraint = historyButton.widthAnchor.constraint(equalToConstant: 44)
        widthConstraint.isActive = true
        historyButtonWidthConstraint = widthConstraint

        NSLayoutConstraint.activate([
            historyButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            historyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            historyButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        historyButton.addTarget(self, action: #selector(historyButtonTapped), for: .touchUpInside)
    }

    func updateHistoryButton(stateController: StateController?) {
        let colour = stateController?.convValues.colour ?? .systemGreen
        let viewIndex = stateController?.convValues.historyButtonViewIndex ?? 0
        
        // Start invisible for fade-in animation
        historyButton.alpha = 0

        switch viewIndex {
        case 0:
            if #available(iOS 15.0, *) {
                var config = UIButton.Configuration.plain()
                config.image = UIImage(systemName: "clock.arrow.circlepath")
                config.baseForegroundColor = colour
                config.background.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
                config.background.cornerRadius = 22
                historyButton.configuration = config
            } else {
                historyButton.setImage(UIImage(systemName: "clock"), for: .normal)
                historyButton.setTitle(nil, for: .normal)
                historyButton.tintColor = colour
                historyButton.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
            }
            historyButton.isHidden = false
            historyButtonWidthConstraint?.constant = 44

        case 1:
            if #available(iOS 15.0, *) {
                var config = UIButton.Configuration.plain()
                config.title = "Calculation History"
                config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                    var outgoing = incoming
                    outgoing.font = UIFont.boldSystemFont(ofSize: 17)
                    return outgoing
                }
                config.baseForegroundColor = colour
                config.background.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
                config.background.cornerRadius = 22
                config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
                historyButton.configuration = config
            } else {
                historyButton.setImage(nil, for: .normal)
                historyButton.setTitle("Calculation History", for: .normal)
                historyButton.tintColor = colour
                historyButton.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
            }
            historyButton.isHidden = false
            // Deactivate old width constraint, let button size itself
            historyButtonWidthConstraint?.isActive = false
            historyButton.setNeedsLayout()
            historyButton.layoutIfNeeded()
            let newWidth = historyButton.intrinsicContentSize.width
            historyButtonWidthConstraint = historyButton.widthAnchor.constraint(equalToConstant: newWidth > 0 ? newWidth : 220)
            historyButtonWidthConstraint?.isActive = true

        case 2:
            historyButton.isHidden = true
            // No animation needed when hidden
            historyButton.alpha = 1
            return

        default:
            fatalError("Unexpected historyButtonViewIndex")
        }
        
        // Fade in to match tab bar transition timing
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseIn) {
            self.historyButton.alpha = 1
        }
    }
}
