//
//  SearchResultModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/15.
//

import Foundation

struct SearchResultModel {
    let query: String
    let products: [SearchProductModel]
    let artists: [SearchArtistModel]
    let category: CategoryType
}
