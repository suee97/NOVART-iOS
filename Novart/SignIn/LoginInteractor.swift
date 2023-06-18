//
//  LoginInteractor.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/02.
//

import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKUser
import SwiftUI

enum SignInProvider: String {
    case kakao
    case google
}

final class LoginInteractor {
    
    @MainActor
    func performGoogleSignIn() async throws -> String {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { throw ServiceError.rootViewControllerNotFound }
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController)
        let accessToken = result.user.accessToken.tokenString
        AuthProperties.shared.signInProvider = .google
        AuthProperties.shared.providerAccessToken = accessToken
        return accessToken
    }
    
    @MainActor
    func performKakaoSignIn() async throws -> OAuthToken {
        return try await withCheckedThrowingContinuation({
                (continuation: CheckedContinuation<OAuthToken, Error>) in
            if (UserApi.isKakaoTalkLoginAvailable()) {
                UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    if let oauthToken = oauthToken {
                        AuthProperties.shared.signInProvider = .kakao
                        AuthProperties.shared.providerAccessToken = oauthToken.accessToken
                        continuation.resume(returning: oauthToken)
                        return
                    } else {
                        continuation.resume(throwing: ServiceError.kakaoTalkLoginUnavailable)
                        return
                    }
                }
            } else {
                continuation.resume(throwing: ServiceError.kakaoTalkLoginUnavailable)
                return 
            }
        })
    }
    
    func login(accessToken: String, provider: SignInProvider) async throws -> Bool {
        let loginResponse = try await APIClient.login(accessToken: accessToken, provider: provider.rawValue)
        guard let isFirst = loginResponse.data?.isFirstLogin else { return true }
        if isFirst {
            return isFirst
        } else {
            guard let accessToken = loginResponse.data?.accessToken, let refreshToken = loginResponse.data?.refreshToken else { return true }
            KeychainService.shared.saveAccessToken(accessToken)
            KeychainService.shared.saveRefreshToken(refreshToken)
            try await getUserInfo()
            return false
        }
    }
    
    private func getUserInfo() async throws {
        let userResponse = try await APIClient.getUser()
        let user = userResponse.data
        AuthProperties.shared.user = user
    }
    
    func setNickname(as nickname: String) async throws -> Bool {
        let result = try await APIClient.setNickname(as: nickname)
        return result.success
    }
}


enum ServiceError: Error {
    case rootViewControllerNotFound
    case kakaoTalkLoginUnavailable
}
