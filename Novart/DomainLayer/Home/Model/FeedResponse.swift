//
//  FeedResponse.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/18.
//

import Foundation

struct FeedResponse: Decodable {
    let size: Int
    let number: Int
    let content: [FeedItem]
    let pageable: String
    let sort: SearchSortData
    let numberOfElements: Int
    let first: Bool
    let last: Bool
    let empty: Bool
}
