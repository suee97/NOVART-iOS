//
//  ProductPreviewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/31.
//

import UIKit

struct ProductPreviewModel {
    let name: String
    let description: String
    let price: Int
    let coverImages: [UIImage]
    let detailImages: [UIImage]
    let artTagList: [String]
    let artist: ProductDetailArtist
    let createdAt: String
    let selectedCategory: CategoryType
    let forSale: Bool
    
    init(name: String, description: String, price: Int, coverImages: [UIImage], detailImages: [UIImage], artTagList: [String], selectedCategory: CategoryType, forSale: Bool) {
        self.name = name
        self.description = description
        self.price = price
        self.artTagList = artTagList
        self.createdAt = Date().toString()
        self.coverImages = coverImages
        self.detailImages = detailImages
        self.selectedCategory = selectedCategory
        let user = Authentication.shared.user
        self.artist = ProductDetailArtist(userId: user?.id ?? 0, nickname: user?.nickname ?? "", profileImageUrl: user?.profileImageUrl, following: false)
        self.forSale = forSale
    }
}
