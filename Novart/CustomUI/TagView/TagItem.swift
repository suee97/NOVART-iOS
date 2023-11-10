//
//  TagItem.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/06.
//

import Foundation

struct TagItem: Identifiable, Hashable {
    var id = UUID()
    
    var tag: String?
    var isSelected: Bool = false
    
    init(tag: String? = nil, isSelected: Bool = false) {
        self.tag = tag
        self.isSelected = isSelected
    }
}
