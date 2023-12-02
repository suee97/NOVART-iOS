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
    
    var id: Int64
    let name: String
    let artist: String
    let imageUrls: [String]
    
    init(_ item: FeedItem) {
        self.id = item.id
        self.name = item.name
        self.artist = item.artistNickname
        self.imageUrls = item.thumbnailImage.map { $0.url }
    }
}
