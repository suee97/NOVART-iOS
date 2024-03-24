//
//  Int+Decimal.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/01/28.
//

import Foundation

extension Int {
    func toDecimalString() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self))
    }
}
