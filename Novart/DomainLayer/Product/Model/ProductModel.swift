//
//  ProductModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/09/24.
//

import Foundation

class ProductModel: PlainItem, Decodable {
    let id: Int64
    let name: String
    let nickname: String
    let thumbnailImageUrl: String?
    
    init(id: Int64, name: String, artistNickname: String, thumbnailImageUrl: String?) {
        self.id = id
        self.name = name
        self.nickname = artistNickname
        self.thumbnailImageUrl = thumbnailImageUrl
    }
}
