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
    let thumbNailImageUrls: [String]
    let artImageUrls: [String]
    let artTagList: [String]
    let artist: ProductDetailArtist
    let createdAt: String
    let liked: Bool
}

struct ProductDetailArtist: Decodable {
    let userId: Int64
    let artistNickname: String
    let profileImageUrl: String?
    let following: Bool
}
