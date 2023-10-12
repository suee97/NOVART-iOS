//
//  SignUpInteractor.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/11.
//

import Foundation

final class SignUpInteractor {
    
    let userInteractor = UserInteractor()
    
    func signUp(marketingPolicySelected: Bool) async throws -> PlainUser {
        guard let provider = Authentication.shared.signInProvider?.rawValue, let providerToken = Authentication.shared.providerAccessToken else {
            throw APIError(message: "", code: .UNKNOWN)
        }
        let response = try await APIClient.signUp(accessToken: providerToken, provider: provider, isMarketingAgree: marketingPolicySelected)
        guard let accessToken = response.accessToken, let refreshToken = response.refreshToken else {
            throw APIError(message: "", code: .UNKNOWN)
        }
        KeychainService.shared.saveAccessToken(accessToken)
        KeychainService.shared.saveRefreshToken(refreshToken)
        Authentication.shared.isFirstLogin = response.isFirstLogin
        return try await userInteractor.getUserInfo()
    }
}
