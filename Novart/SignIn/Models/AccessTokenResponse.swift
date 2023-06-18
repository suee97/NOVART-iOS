//
//  AccessTokenResponse.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/29.
//

import Foundation

struct AccessTokenResponse: Codable {
    let accessToken: String?
    let refreshToken: String?
    let isFirstLogin: Bool
}
