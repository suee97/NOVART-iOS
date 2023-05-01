//
//  APIClient+SignIn.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/29.
//

import Alamofire
import Foundation

extension APIClient {
    static func signIn(accessToken: String, provider: String) async throws -> SignInResponse {
        try await APIClient.request(target: AuthTarget.signIn(accessToken: accessToken, provider: provider), type: SignInResponse.self)
    }
}
