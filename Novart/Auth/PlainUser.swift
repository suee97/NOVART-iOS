//
//  PlainUser.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/02.
//

import Foundation

struct PlainUser: Codable {
    let id: Int64
    let nickname: String
    let profileImageUrl: String?
    let backgroundImageUrl: String?
    let tags: [String]
    let jobs: [String]
    let email: String?
    let openChatUrl: String?
    let following: Bool
}
