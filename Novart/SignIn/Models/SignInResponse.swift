//
//  SignInResponse.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/29.
//

import Foundation

struct SignInResponse: Codable {
    let success: Bool
    let code: Int
    let message: String
    let data: AccessToken?
}

extension SignInResponse {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? 0
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        data = try values.decodeIfPresent(AccessToken.self, forKey: .data)
    }
}

struct AccessToken: Codable {
    let accessToken: String
    let refreshToken: String
    let isFirstLogin: Bool
}
