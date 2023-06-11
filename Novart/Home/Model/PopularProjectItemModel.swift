//
//  PopularProjectItemModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/26.
//

import Foundation

enum NovartItemCategory: String, Codable {
    case painting = "painting"
    case furniture = "furniture"
    case light = "light"
    case craft = "craft"
    case all = "all"
}

struct PopularProductItemModel: Codable {
    let id: String
    let thumbnailImageUrl: String?
    let name: String?
    let category: NovartItemCategory
    let seller: String?
    let likes: Bool
    let price: Int
    let productStatus: ItemStatus
}
