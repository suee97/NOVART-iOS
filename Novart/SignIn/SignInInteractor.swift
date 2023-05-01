//
//  SignInInteractor.swift
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

final class SignInInteractor {
    
    @MainActor
    func performGoogleSignIn() async throws -> GIDSignInResult {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { throw ServiceError.rootViewControllerNotFound }
        return try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController)
    }
    
    @MainActor
    func performKakaoSignIn() async throws -> OAuthToken {
        return try await withCheckedThrowingContinuation({
                (continuation: CheckedContinuation<OAuthToken, Error>) in
            if (UserApi.isKakaoTalkLoginAvailable()) {
                UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                    if let error = error {
                        continuation.resume(throwing: error)
                    }
                    
                    if let oauthToken = oauthToken {
                        continuation.resume(returning: oauthToken)
                    } else {
                        continuation.resume(throwing: ServiceError.kakaoTalkLoginUnavailable)
                    }
                }
            } else {
                continuation.resume(throwing: ServiceError.kakaoTalkLoginUnavailable)
            }
        })
    }
    
    func signInToServer(accessToken: String, provider: SignInProvider) async throws {
        let signInResponse = try await APIClient.signIn(accessToken: accessToken, provider: provider.rawValue)
        guard let token = signInResponse.data else { return }
        KeychainService.shared.saveAccessToken(token.accessToken)
        KeychainService.shared.saveRefreshToken(token.refreshToken)
        print("access token success!")
    }
}


enum ServiceError: Error {
    case rootViewControllerNotFound
    case kakaoTalkLoginUnavailable
}
