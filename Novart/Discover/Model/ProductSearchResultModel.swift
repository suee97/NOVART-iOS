//
//  ProductSearchResultModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/28.
//

import Foundation

struct ProductSearchResultModel: Codable {
    let content: [PopularProductItemModel]
    let size: Int
    let number: Int
    let numberOfElements: Int
    let first: Bool
    let last: Bool
    let empty: Bool
    let pageable: PageInfoModel
    let sort: SortInfoModel
}
