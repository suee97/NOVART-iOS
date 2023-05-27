//
//  UserDTO.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/07.
//

import Foundation

struct UserResponse: Codable {
    let success: Bool
    let code: Int
    let message: String
    let data: UserDTO?
}

enum UserRole: String, Codable {
    case user = "USER"
    case seller = "SELLER"
    
    init(from decoder: Decoder) throws {
        self = try UserRole(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .user
    }
}

struct UserDTO: Codable {
    let id: Int
    let nickname: String
    let role: UserRole
    let introduction: String?
}

extension UserResponse {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? 0
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        data = try values.decodeIfPresent(UserDTO.self, forKey: .data)
    }
}
