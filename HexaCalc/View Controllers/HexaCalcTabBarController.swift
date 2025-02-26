//
//  HexaCalcTabBarController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2025-02-26.
//  Copyright © 2025 Anthony Hopkins. All rights reserved.
//

import UIKit

class HexaCalcTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 17.0, *) {
            traitOverrides.horizontalSizeClass = .compact
        }
    }
}
