//
//  Formatter+BinaryString.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2020-07-24.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import Foundation

extension String {

    func separate(every: Int, with separator: String) -> String {
        return String(stride(from: 0, to: Array(self).count, by: every).map {
            Array(Array(self)[$0..<min($0 + every, Array(self).count)])
        }.joined(separator: separator))
    }
}
