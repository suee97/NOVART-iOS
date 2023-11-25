//
//  TagItem.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/06.
//

import Foundation

struct TagItem: Identifiable, Hashable {
    var id: UUID
    
    var tag: String?
    var isSelected: Bool = false
    
    init(id: UUID = UUID(), tag: String? = nil, isSelected: Bool = false) {
        self.id = id
        self.tag = tag
        self.isSelected = isSelected
    }
}
