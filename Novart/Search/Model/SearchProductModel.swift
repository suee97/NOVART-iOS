//
//  SearchProductModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/09/24.
//

import Foundation

class SearchProductModel: PlainItem, Decodable {
    let id: Int64
    let name: String
    let artistNickname: String
    let thumbnailImageUrl: String?
    
    init(id: Int64, name: String, artistNickname: String, thumbnailImageUrl: String?) {
        self.id = id
        self.name = name
        self.artistNickname = artistNickname
        self.thumbnailImageUrl = thumbnailImageUrl
    }
}
