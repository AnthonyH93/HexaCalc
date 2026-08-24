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
        let activeScene = UIApplication.shared.connectedScenes
            .first { $0.activationState == .foregroundActive } as? UIWindowScene
        return activeScene?.interfaceOrientation.isLandscape ?? false
    }
}
