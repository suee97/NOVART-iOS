//
//  TokenRefreshResponse.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/22.
//

import Foundation

struct TokenRefreshResponse: Codable {
    let accessToken: String
    let refreshToken: String
}
