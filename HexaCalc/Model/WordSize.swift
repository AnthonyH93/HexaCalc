//
//  WordSize.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2026-11-12.
//  Copyright © 2026 Anthony Hopkins. All rights reserved.
//

import Foundation

// The integer width the Hexadecimal and Binary calculators operate in. Values are always
// held as signed (two's complement) Int64s — at sizes below 64 bits only the low `bits`
// bits are meaningful and the rest is sign-extension, so the Decimal tab (which stays
// 64-bit) reads the signed value of whatever Hex/Binary currently hold.
enum WordSize: Int, CaseIterable {
    case bits8 = 8
    case bits16 = 16
    case bits32 = 32
    case bits64 = 64

    static let defaultSize: WordSize = .bits64

    var bits: Int { rawValue }
    var hexDigits: Int { bits / 4 }
    var title: String { "\(bits)-bit" }

    // Mask selecting the low `bits` bits of a 64-bit pattern
    var mask: UInt64 { bits == 64 ? .max : (UInt64(1) << UInt64(bits)) - 1 }

    // Keeps the low `bits` bits and sign-extends them back to an Int64 — i.e. two's
    // complement wraparound. A no-op at 64 bits.
    func truncate(_ value: Int64) -> Int64 {
        guard bits < 64 else { return value }
        let shift = Int64(64 - bits)
        return (value << shift) >> shift
    }

    // Converts a value held at another word size to this one by keeping its bit pattern:
    // growing zero-extends (8-bit A5 becomes 16-bit 00A5, not FFA5) and shrinking keeps
    // the low bits (16-bit 1234 becomes 8-bit 34). The bits are what the Hexadecimal and
    // Binary tabs show, so they're what stays put — the signed value can change.
    func resized(_ value: Int64, from oldSize: WordSize) -> Int64 {
        truncate(Int64(bitPattern: oldSize.pattern(value)))
    }

    // The unsigned `bits`-wide bit pattern of a value
    func pattern(_ value: Int64) -> UInt64 {
        UInt64(bitPattern: value) & mask
    }

    // Unpadded uppercase hex digits of the value's bit pattern ("FF" for -1 at 8 bits)
    func hexString(_ value: Int64) -> String {
        String(pattern(value), radix: 16).uppercased()
    }

    // Unpadded binary digits of the value's bit pattern ("11111111" for -1 at 8 bits)
    func binaryString(_ value: Int64) -> String {
        String(pattern(value), radix: 2)
    }

    // Parses a bit pattern typed or shown on a calculator (no sign, at most 64 bits
    // worth of digits) and interprets it as a signed value of this width — a pattern
    // whose top bit (bit `bits - 1`) is set is negative.
    func value(fromPattern pattern: String, radix: Int) -> Int64? {
        guard let unsigned = UInt64(pattern, radix: radix) else { return nil }
        return truncate(Int64(bitPattern: unsigned))
    }

    // Parses a value shared between tabs through StateController, which may be either a
    // signed number ("-ff", as Decimal and the result paths write it) or an unsigned bit
    // pattern ("FFFFFFFFFFFFFFFF", as the typing paths have historically written it),
    // and wraps it to this width.
    func value(fromShared string: String, radix: Int) -> Int64? {
        if string.hasPrefix("-") {
            guard let signed = Int64(string, radix: radix) else { return nil }
            return truncate(signed)
        }
        return value(fromPattern: string, radix: radix)
    }
}
