//
//  SignUpRequestBody.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/22.
//

import Foundation

struct SignUpRequestBody: Codable {
    let oauthAccessToken: OAuthAccessTokenInfo
    let policies: PolicyAgreementInfo
}

struct OAuthAccessTokenInfo: Codable {
    let provider: String
    let accessToken: String
}

struct PolicyAgreementInfo: Codable {
    let termsOfService: Bool
    let useOfPersonalInfo: Bool
    let receiveMarketingInfo: Bool
}
