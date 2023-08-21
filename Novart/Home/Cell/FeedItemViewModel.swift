//
//  FeedItemViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/08/19.
//

import Foundation

final class FeedItemViewModel: Identifiable, Hashable {
    static func == (lhs: FeedItemViewModel, rhs: FeedItemViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(imageUrls)
    }
    
    var id = UUID()
    let name: String
    let artist: String
    let imageUrls: [String] = ["mock_chair", "mock_catalog_poster"]
    
    init(_ item: FeedItem) {
        self.name = item.name
        self.artist = item.artist
    }
}
