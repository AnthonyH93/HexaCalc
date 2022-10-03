//
//  Formatter+BinaryString.swift
//  HexaCalcUITests
//
//  Created by Anthony Hopkins on 2022-10-03.
//  Copyright © 2022 Anthony Hopkins. All rights reserved.
//

import Foundation

extension String {

    func separate(every: Int, with separator: String) -> String {
        return String(stride(from: 0, to: Array(self).count, by: every).map {
            Array(Array(self)[$0..<min($0 + every, Array(self).count)])
        }.joined(separator: separator))
    }
}
