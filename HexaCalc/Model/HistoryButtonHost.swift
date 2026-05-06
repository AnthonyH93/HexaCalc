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
    var historyButtonHorizontalConstraint: NSLayoutConstraint? { get set }
    var historyButtonTopConstraint: NSLayoutConstraint? { get set }
    func historyButtonTapped()
}

extension HistoryButtonHost where Self: UIViewController {

    // Subclasses that own an output label can return it here so
    // repositionHistoryButton can anchor below it on short screens.
    var historyButtonAnchorLabel: UILabel? { nil }

    func presentHistory(calculationHistory: [CalculationData]) {
        guard let historyVC = storyboard?.instantiateViewController(withIdentifier: "CalculationHistoryViewController") as? CalculationHistoryViewController else { return }
        historyVC.calculationHistory = calculationHistory
        let nav = UINavigationController(rootViewController: historyVC)
        present(nav, animated: true)
    }

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

        let horizontalConstraint = historyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        horizontalConstraint.isActive = true
        historyButtonHorizontalConstraint = horizontalConstraint

        let topConstraint = historyButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60)
        topConstraint.isActive = true
        historyButtonTopConstraint = topConstraint

        historyButton.heightAnchor.constraint(equalToConstant: 44).isActive = true

        historyButton.accessibilityIdentifier = "History Button"
        historyButton.addTarget(self, action: #selector(historyButtonTapped), for: .touchUpInside)
    }

    func repositionHistoryButton(for targetSize: CGSize? = nil) {
        guard historyButton?.superview != nil else { return }

        let size = targetSize ?? view.bounds.size
        let isLandscape = size.width > size.height

        historyButtonTopConstraint?.isActive = false
        let topConstraint: NSLayoutConstraint
        if isLandscape {
            topConstraint = historyButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        } else if size.height <= 736, let anchorLabel = historyButtonAnchorLabel {
            // On short iPhones (≤736pt: iPhone 8, SE, 7/8 Plus) the output label sits
            // high enough that view.topAnchor+60 lands inside it — anchor below instead.
            topConstraint = historyButton.topAnchor.constraint(equalTo: anchorLabel.bottomAnchor, constant: 8)
        } else {
            topConstraint = historyButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60)
        }
        topConstraint.isActive = true
        historyButtonTopConstraint = topConstraint
    }

    func updateHistoryButton(stateController: StateController?) {
        let historyEnabled = stateController?.convValues.historyEnabled ?? true

        guard historyEnabled else {
            historyButton.isHidden = true
            historyButton.alpha = 1
            return
        }

        repositionHistoryButton()

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

        default:
            fatalError("Unexpected historyButtonViewIndex")
        }

        // Fade in to match tab bar transition timing
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseIn) {
            self.historyButton.alpha = 1
        }
    }
}
