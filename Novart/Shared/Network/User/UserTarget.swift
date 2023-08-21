//
//  UserTarget.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/22.
//

import Alamofire
import Foundation

enum UserTarget: TargetType {
    case getUser
    case setNickname(nickname: String)
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case .getUser:
            return "users/me"
        case .setNickname:
            return "users/me/nickname"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUser:
            return .get
        case .setNickname:
            return .patch
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getUser:
            return .query(nil)
        case let .setNickname(nickname):
            return .body(["nickname": nickname])
        }
    }
}

