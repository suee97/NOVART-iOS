//
//  Authentication.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/02.
//

import UIKit

final class Authentication {
    
    static let shared: Authentication = Authentication()
    
    var signInProvider: SignInProvider?
    var providerAccessToken: String?
    var user: PlainUser?
    var isFirstLogin: Bool = false
    
    let userInteractor: UserInteractor = .init()
}


extension Authentication {
    func login() async {
        if let refreshToken = KeychainService.shared.refreshToken,
           let signInProvider = SignInProvider(rawValue: KeychainService.shared.signInProvider ?? "") {
            do {
                let (accessToken, refreshToken) = try await loginWithRefreshToken(refreshToken: refreshToken)
                KeychainService.shared.saveAccessToken(accessToken)
                KeychainService.shared.saveRefreshToken(refreshToken)
                _ = try await userInteractor.getUserInfo()
                await UIApplication.shared.appCoordinator?.navigate(to: .main)
            } catch {
                KeychainService.shared.removeToken()
                await showLoginScene()
            }
        } else {
            await showLoginScene()
        }
    }
    
    func showLoginScene() async {
        await UIApplication.shared.appCoordinator?.navigate(to: .login)
    }
}

private extension Authentication {
    
    @discardableResult
    func loginWithRefreshToken(refreshToken: String) async throws -> (String, String) {
        
        let url = URL(string: API.baseURL + "auth/refresh")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let authHeaderValue = "Bearer \(refreshToken)"
        request.addValue(authHeaderValue, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let tokens: (String, String) = try await withCheckedThrowingContinuation { continuation in
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume(throwing: APIError.init(message: "Unknown Error", code: .TokenRefreshFail))
                    return
                }

                let decoder = JSONDecoder()
                let decodedData = try? decoder.decode(TokenRefreshResponse.self, from: data)
                guard let token = decodedData else {
                    continuation.resume(throwing: APIError(message: "refresh token decoding fail", code: .TokenRefreshFail))
                    return
                }
                continuation.resume(returning: (token.accessToken, token.refreshToken))
            }
            
            task.resume()
        }
        
        return tokens
    }
    
    
}
