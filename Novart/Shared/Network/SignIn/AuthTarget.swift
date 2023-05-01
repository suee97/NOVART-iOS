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
        case let .signIn(_, provider):
            return "auth/\(provider)"
        }
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: RequestParams {
        switch self {
        case let .signIn(accessToken, _):
            return .body(["accessToken": accessToken])
        }
    }
}
