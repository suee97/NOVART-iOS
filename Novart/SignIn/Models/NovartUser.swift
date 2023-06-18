//
//  NovartUser.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/07.
//

import Foundation

enum UserRole: String, Codable {
    case user = "USER"
    case seller = "SELLER"
    
    init(from decoder: Decoder) throws {
        self = try UserRole(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .user
    }
}

struct NovartUser: Codable {
    let id: String
    let nickname: String
    let role: UserRole
    let email: String?
}
