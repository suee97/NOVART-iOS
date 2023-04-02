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

final class SignInInteractor {
    
    @MainActor
    func performGoogleSignIn() async throws -> GIDSignInResult {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { throw ServiceError.rootViewControllerNotFound }
        return try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController)
    }
    
    func performKakaoSignIn() async throws -> User {
        _ = try await signInToKakaoTalk()
        return try await withCheckedThrowingContinuation({
                (continuation: CheckedContinuation<User, Error>) in
            UserApi.shared.me { user, error in
                if let error = error {
                    continuation.resume(throwing: error)
                }
                
                if let user = user {
                    continuation.resume(returning: user)
                } else {
                    continuation.resume(throwing: ServiceError.kakaoTalkLoginUnavailable)
                }
            }
        })
    }
    
    private func signInToKakaoTalk() async throws -> OAuthToken {
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
}


enum ServiceError: Error {
    case rootViewControllerNotFound
    case kakaoTalkLoginUnavailable
}
