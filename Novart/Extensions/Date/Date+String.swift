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

extension String {
    func toFormattedString() -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        inputFormatter.locale = Locale(identifier: "ko_KR")
        
        if let date = inputFormatter.date(from: self) {
            return date.toString()
        } else {
            return nil
        }
    }
}
