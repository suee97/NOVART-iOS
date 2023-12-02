//
//  ExhibitionDetailItem.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/05.
//

import Foundation

class ExhibitionDetailItem: Hashable {
    let id = UUID()
    
    static func == (lhs: ExhibitionDetailItem, rhs: ExhibitionDetailItem) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
