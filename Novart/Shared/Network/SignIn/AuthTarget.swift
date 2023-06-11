//
//  AuthTarget.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/29.
//

import Alamofire
import Foundation

enum AuthTarget: TargetType {
    case signIn(accessToken: String, provider: String)
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case .signIn:
            return "signup"
        }
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: RequestParams {
        switch self {
        case let .signIn(accessToken, provider):
            return .body([
                "provider": provider,
                "accessToken": accessToken
            ])
        }
    }
}
