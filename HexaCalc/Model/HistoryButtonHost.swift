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
    func historyButtonTapped()
}

extension HistoryButtonHost where Self: UIViewController {

    func setupHistoryButton() {
        historyButton = UIButton(type: .system)
        historyButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(historyButton)

        NSLayoutConstraint.activate([
            historyButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            historyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            historyButton.widthAnchor.constraint(equalToConstant: 44),
            historyButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        historyButton.addTarget(self, action: #selector(historyButtonTapped), for: .touchUpInside)
    }

    func updateHistoryButton(stateController: StateController?) {
        let colour = stateController?.convValues.colour ?? .systemGreen
        let viewIndex = stateController?.convValues.historyButtonViewIndex ?? 0

        switch viewIndex {
        case 0:
            if #available(iOS 14.0, *) {
                historyButton.setImage(UIImage(systemName: "clock.arrow.circlepath"), for: .normal)
            } else {
                historyButton.setImage(UIImage(systemName: "clock"), for: .normal)
            }
            historyButton.setTitle(nil, for: .normal)
            historyButton.isHidden = false
            historyButton.tintColor = colour
        case 1:
            historyButton.setImage(nil, for: .normal)
            historyButton.setTitle("History", for: .normal)
            historyButton.isHidden = false
            historyButton.tintColor = colour
        case 2:
            historyButton.isHidden = true
        default:
            fatalError("Unexpected historyButtonViewIndex")
        }
    }
}
