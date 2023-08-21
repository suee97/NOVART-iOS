//
//  AuthTarget.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/22.
//

import Alamofire
import Foundation

enum AuthTarget: TargetType {
    case signUp(signUpInfo: SignUpRequestBody)
    case login(accessToken: String, provider: String)
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "signup"
        case .login:
            return "auth"
        }
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: RequestParams {
        switch self {
        case let .signUp(signUpInfo):
            return .body(signUpInfo)
        case let .login(accessToken, provider):
            return .body([
                "provider": provider,
                "accessToken": accessToken
            ])
        }
    }
}
