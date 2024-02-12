//
//  Date+String.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/31.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd" // "2022. 10. 11"
        return dateFormatter.string(from: self)
    }
}
