//
//  ProductDetailModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/28.
//

import Foundation

enum ItemStatus: String, Codable {
    case proceeding = "PROCEEDING"
    case cancel = "CANCEL"
    case complete = "COMPLETE"
}

struct ProductDetailModel: Codable {
    let id: String
    let name: String?
    let price: Int
    let category: NovartItemCategory
    let thumbnailImageUrl: String?
    let detailedImageUrls: [String]
    let validationImageUrls: [String]
    let productStatus: ItemStatus
    let description: String?
    let materials: [String]
    let width: Int
    let depth: Int
    let height: Int
    let likes: Bool
    let productStartDate: String?
    let productEndDate: String?
    let seller: SellerModel
}
