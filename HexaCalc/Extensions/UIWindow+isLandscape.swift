//
//  UIWindow+isLandscape.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2021-02-25.
//  Copyright © 2021 Anthony Hopkins. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {
    static var isLandscape: Bool {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows
                .first?
                .windowScene?
                .interfaceOrientation
                .isLandscape ?? false
        } else {
            return UIApplication.shared.statusBarOrientation.isLandscape
        }
    }
}
