//
//  SearchArtistModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/15.
//

import Foundation

struct SearchArtistModel: Identifiable, Hashable, Decodable {
    let id: Int64
    let nickname: String
    let backgroundImgUrl: String?
    let profileImgUrl: String?
}
