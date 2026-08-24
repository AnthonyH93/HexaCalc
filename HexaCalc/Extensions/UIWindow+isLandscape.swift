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
        UIApplication.shared.windows
            .first?
            .windowScene?
            .interfaceOrientation
            .isLandscape ?? false
    }
}
