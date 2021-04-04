//
//  Formatter+ScientificNotation.swift
//  BasicCalculator
//
//  Created by Anthony Hopkins on 2020-07-17.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import Foundation

//Extension for scientific notation conversion within calculator app
extension Formatter {
    static let scientific: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.positiveFormat = "0.#####E0"
        formatter.exponentSymbol = "e"
        return formatter
    }()
}

extension Numeric {
    var scientificFormatted: String {
        return Formatter.scientific.string(for: self) ?? ""
    }
}
