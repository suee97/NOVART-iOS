//
//  PlainItem.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/22.
//

import Foundation

class PlainItem: Hashable {
    let uuid = UUID()
    
    static func == (lhs: PlainItem, rhs: PlainItem) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
