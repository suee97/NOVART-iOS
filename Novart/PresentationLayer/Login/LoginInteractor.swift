//
//  LoginInteractor.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/02.
//

import Foundation
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKUser

final class LoginInteractor {
    
    let userInteractor = UserInteractor()
    
    @MainActor
    func performGoogleSignIn() async throws -> String {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { throw ServiceError.rootViewControllerNotFound }
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController)
        let accessToken = result.user.accessToken.tokenString
        Authentication.shared.signInProvider = .google
        Authentication.shared.providerAccessToken = accessToken
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
                        Authentication.shared.signInProvider = .kakao
                        Authentication.shared.providerAccessToken = oauthToken.accessToken
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
    
    @discardableResult
    func login(accessToken: String, provider: SignInProvider) async throws -> Bool {
        let loginResponse = try await APIClient.login(accessToken: accessToken, provider: provider.rawValue)
        let isFirst = loginResponse.isFirstLogin
        if isFirst {
            return isFirst
        } else {
            guard let accessToken = loginResponse.accessToken, let refreshToken = loginResponse.refreshToken else { return true }
            KeychainService.shared.saveAccessToken(accessToken)
            KeychainService.shared.saveRefreshToken(refreshToken)
            KeychainService.shared.saveSignInProvider(provider)
            _ = try await userInteractor.getUserInfo()
            return false
        }
    }
}
