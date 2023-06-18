//
//  TokenRefreshResponse.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/18.
//

import Foundation

struct TokenRefreshResponse: Codable {
    let accessToken: String
    let refreshToken: String
}
