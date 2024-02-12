//
//  ArtistModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/15.
//

import Foundation

struct ArtistModel: Identifiable, Hashable, Decodable {
    let id: Int64
    let nickname: String
    let backgroundImageUrl: String?
    let profileImageUrl: String?
}
