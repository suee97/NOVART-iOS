//
//  FeedItem.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/08/19.
//

import Foundation

struct FeedItem: Decodable {
    let id: Int64
    let name: String
    let nickname: String
    let category: CategoryType
    let thumbnailImageUrl: [ThumbnailImage]
    let likes: Bool
}

struct ThumbnailImage: Decodable {
    let url: String
}
