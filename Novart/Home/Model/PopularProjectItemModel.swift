//
//  PopularProjectItemModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/26.
//

import Foundation

enum NovartItemCategory: String, Codable {
    case table = "탁자"
}

struct PopularProductItemModel: Codable {
    let id: String
    let thumbnail: String?
    let name: String?
    let category: NovartItemCategory
    let seller: String?
    let likes: Bool
    let price: Int
}
