//
//  SellerModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/28.
//

import Foundation

struct SellerModel: Codable {
    let id: String
    let nickname: String
    let introduction: String?
    let profileImageUrl: String?
}
