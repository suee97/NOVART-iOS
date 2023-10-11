//
//  APIClient+SignIn.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/22.
//

import Alamofire
import Foundation

extension APIClient {
    static func signUp(accessToken: String, provider: String, isMarketingAgree: Bool) async throws ->AccessTokenResponse {
        let oAuthAccessToken = OAuthAccessTokenInfo(provider: provider, accessToken: accessToken)
        let policyAgreementInfo = PolicyAgreementInfo(termsOfService: true, useOfPersonalInfo: true, receiveMarketingInfo: isMarketingAgree)
        return try await APIClient.request(target: AuthTarget.signUp(signUpInfo: SignUpRequestBody(oauthAccessToken: oAuthAccessToken, policies: policyAgreementInfo)), type: AccessTokenResponse.self)
    }
    
    static func login(accessToken: String, provider: String) async throws -> AccessTokenResponse {
        try await APIClient.request(target: AuthTarget.login(accessToken: accessToken, provider: provider), type: AccessTokenResponse.self)
    }
}

