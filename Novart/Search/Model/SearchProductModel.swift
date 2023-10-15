//
//  SearchProductModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/09/24.
//

import Foundation

struct SearchProductModel: Identifiable, Hashable, Decodable {
    let id: Int64
    let name: String
    let artistNickname: String
    let thumbnailImageUrl: String?
}
