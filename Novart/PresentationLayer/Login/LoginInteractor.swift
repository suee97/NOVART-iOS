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
import AuthenticationServices

final class LoginInteractor: NSObject, ASAuthorizationControllerDelegate {
    
    let userInteractor = UserInteractor()
    
    private var authorizationContinuation: CheckedContinuation<String, Error>?
    weak var presentationContextProvider: ASAuthorizationControllerPresentationContextProviding?
    
    @MainActor
    func performGoogleSignIn() async throws -> String {
        guard let presentingViewController = UIApplication.getTopViewController() else {
            throw ServiceError.rootViewControllerNotFound
        }
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
                UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
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
                
            }
        })
    }
    
    @MainActor
    func performAppleLogin() async throws -> String {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = presentationContextProvider
        
        return try await withCheckedThrowingContinuation { continuation in
            authorizationContinuation = continuation
            authorizationController.performRequests()
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let identityToken = appleIDCredential.identityToken {
            let token = String(decoding: identityToken, as: UTF8.self)
            Authentication.shared.signInProvider = .apple
            Authentication.shared.providerAccessToken = token
            authorizationContinuation?.resume(returning: token)
        } else {
            authorizationContinuation?.resume(throwing: LoginError.emptyToken)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        if let error = error as? ASAuthorizationError, error.code == .canceled {
            authorizationContinuation?.resume(throwing: LoginError.sdkLoginCancel)
        } else {
            authorizationContinuation?.resume(throwing: LoginError.sdkError)
        }
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

enum LoginError: Error {
    case emptyToken
    case sdkLoginCancel
    case sdkError
}
