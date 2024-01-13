//
//  ProductUploadRequestModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/01/07.
//

import Foundation

struct ProductUploadRequestModel: Codable {
    let name: String
    let price: Int
    let category: String
    let description: String
    let forSale: Bool
    let thumbnailImageUrls: [String]
    let artImageUrls: [String]
    let artTagList: [String]
}
