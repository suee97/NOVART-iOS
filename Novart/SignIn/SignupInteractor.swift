//
//  SignupInteractor.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/18.
//

import Foundation

final class SignupInteractor {
    func signup(isMarketingAgree: Bool) async throws -> Bool {
        guard let accessToken = AuthProperties.shared.providerAccessToken, let provider = AuthProperties.shared.signInProvider else { return false }
        
        let signupResponse = try await APIClient.signUp(accessToken: accessToken, provider: provider.rawValue, isMarketingAgree: isMarketingAgree)
        guard let accessToken = signupResponse.data?.accessToken, let refreshToken = signupResponse.data?.refreshToken else { return false }
        KeychainService.shared.saveAccessToken(accessToken)
        KeychainService.shared.saveRefreshToken(refreshToken)
        try await getUserInfo()
        return true
    }
    
    private func getUserInfo() async throws {
        let userResponse = try await APIClient.getUser()
        let user = userResponse.data
        AuthProperties.shared.user = user
    }
}
