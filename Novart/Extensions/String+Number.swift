//
//  String+Number.swift
//  Novart
//
//  Created by Jinwook Huh on 3/3/24.
//

import Foundation

extension String {
    var containsOnlyDigits: Bool {
        return self.allSatisfy { $0.isWholeNumber }
    }
}
