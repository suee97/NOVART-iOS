//
//  PopularItemModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/27.
//

import Foundation


struct PopularItemModel: Codable, Equatable {
    let id: String
    let thumbnail: String?
    let name: String?
    let category: NovartItemCategory
    let seller: String?
    let likes: Bool
    let price: Int
}

