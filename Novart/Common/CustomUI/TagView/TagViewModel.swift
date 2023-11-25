//
//  TagViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/07.
//

import Foundation

final class TagViewModel {
    
    private var tagItems: [TagItem] = []
    
    func setTagItems(_ items: [TagItem]) {
        tagItems = items
    }
    
    func add(_ item: TagItem) {
        tagItems.append(item)
    }
    
    @discardableResult
    func delete(_ id: TagItem.ID) -> Bool {
        var deleted = false
        if let index = tagItems.firstIndex(where: { $0.id == id }) {
            tagItems.remove(at: index)
            deleted = true
        }
        return deleted
    }
    
    @discardableResult
    func update(_ item: TagItem) -> TagItem? {
        var itemToReturn: TagItem?
        
        if let index = tagItems.firstIndex(where: { $0.id == item.id }) {
            tagItems[index] = item
            itemToReturn = item
        }
        return itemToReturn
    }
    
    func update(id: TagItem.ID, isSelected: Bool) {
        if let index = tagItems.firstIndex(where: { $0.id == id }) {
            tagItems[index].isSelected = isSelected
        }
    }
    
    func item(with id: TagItem.ID) -> TagItem? {
        return tagItems.first(where: { $0.id == id })
    }
    
    func tagIDs() -> [TagItem.ID] {
        return tagItems.map { $0.id }
    }
    
    func items() -> [TagItem] {
        return tagItems.filter { $0.tag != nil }
    }
}
