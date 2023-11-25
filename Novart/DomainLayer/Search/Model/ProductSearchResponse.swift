//
//  ProductSearchResponse.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/15.
//

import Foundation

struct ProductSearchResponse: Decodable {
    let size: Int
    let number: Int
    let content: [SearchProductModel]
    let sort: SearchSortData
    let numberOfElements: Int
    let pageable: SearchPageData
    let first: Bool
    let last: Bool
    let empty: Bool
}

struct SearchSortData: Decodable {
    let empty: Bool
    let sorted: Bool
    let unsorted: Bool
}

struct SearchPageData: Decodable {
    let offset: Int
    let pageNumber: Int
    let pageSize: Int
    let paged: Bool
    let unpaged: Bool
    let sort: SearchSortData
}
