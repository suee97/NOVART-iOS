//
//  SearchResultModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/15.
//

import Foundation

struct SearchResultModel {
    let query: String
    let products: [ProductModel]
    let artists: [ArtistModel]
    let category: CategoryType
    let isLastPage: (products: Bool, artists: Bool)
}
