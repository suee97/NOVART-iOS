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
    let coverImages: [UploadMediaItem]
    let detailImages: [UploadMediaItem]
    let artTagList: [String]
    let artist: ProductDetailArtist
    let createdAt: String
    let selectedCategory: CategoryType
    let forSale: Bool
    
    init(uploadModel: ProductUploadModel) {
        self.name = uploadModel.name ?? ""
        self.description = uploadModel.description ?? ""
        self.price = Int(uploadModel.price ?? 0)
        self.artTagList = uploadModel.artTagList
        self.createdAt = Date().toString()
        self.coverImages = uploadModel.coverImages
        self.detailImages = uploadModel.detailImages
        self.selectedCategory = uploadModel.category
        let user = Authentication.shared.user
        self.artist = ProductDetailArtist(userId: user?.id ?? 0, nickname: user?.nickname ?? "", profileImageUrl: user?.profileImageUrl, following: false)
        self.forSale = uploadModel.forSale
    }
}
