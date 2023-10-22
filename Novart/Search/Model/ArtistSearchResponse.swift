//
//  ArtistSearchResponse.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/15.
//

import Foundation

struct ArtistSearchResponse: Decodable {
    let size: Int
    let number: Int
    let content: [SearchArtistModel]
    let sort: SearchSortData
    let numberOfElements: Int
    let pageable: SearchPageData
    let first: Bool
    let last: Bool
    let empty: Bool
}
