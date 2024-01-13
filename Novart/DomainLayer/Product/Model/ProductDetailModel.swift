//
//  ProductDetailModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/22.
//

import Foundation

struct ProductDetailModel: Decodable {
    let id: Int64
    let name: String
    let description: String
    let price: Int64
    let thumbnailImageUrls: [String]
    let artImageUrls: [String]
    let artTagList: [String]
    let artist: ProductDetailArtist
    let createdAt: String
    let likes: Bool
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case description
        case price
        case thumbnailImageUrls
        case artImageUrls
        case artTagList
        case artist
        case createdAt
        case likes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.price = try container.decode(Int64.self, forKey: .price)
        self.thumbnailImageUrls = try container.decode([String].self, forKey: .thumbnailImageUrls)
        self.artImageUrls = try container.decode([String].self, forKey: .artImageUrls)
        self.artTagList = try container.decode([String].self, forKey: .artTagList)
        self.artist = try container.decode(ProductDetailArtist.self, forKey: .artist)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.likes = try container.decode(Bool.self, forKey: .likes)
    }
    
    init(previewData: ProductPreviewModel) {
        self.id = -1
        self.name = previewData.name
        self.description = previewData.description
        self.price = Int64(previewData.price)
        self.thumbnailImageUrls = []
        self.artImageUrls = []
        self.artTagList = previewData.artTagList
        let user = Authentication.shared.user
        self.artist = ProductDetailArtist(userId: user?.id ?? 0, nickname: user?.nickname ?? "", profileImageUrl: user?.profileImageUrl, following: false)
        self.createdAt = previewData.createdAt
        self.likes = false
    }
}

struct ProductDetailArtist: Decodable {
    let userId: Int64
    let nickname: String
    let profileImageUrl: String?
    let following: Bool
}
