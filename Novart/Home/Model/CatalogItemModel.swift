//
//  CatalogItemModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/26.
//

import Foundation

enum CatalogItemCategory: String, Codable {
    case graduation = "GRADUATION"
    case artist = "ARTIST"
    case art = "ART"
}

struct CatalogItemModel: Codable, Equatable {
    let id: String
    let imageUrl: String?
    let name: String?
    let category: CatalogItemCategory
    let duration: String?
    let location: String?
    let price: String?
}
