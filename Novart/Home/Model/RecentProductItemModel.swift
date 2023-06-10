//
//  RecentProductItemModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/26.
//

import Foundation

struct RecentProductItemModel: Codable {
    let id: String
    let thumbnailImageUrl: String?
    let name: String?
    let category: NovartItemCategory
    let seller: String?
    let likes: Bool
    let price: Int
    let productStatus: ItemStatus
}
