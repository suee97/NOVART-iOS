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
    case checkValidNickname(nickname: String)
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case .getUser:
            return "users/me/info"
        case .setNickname:
            return "users/me/nickname"
        case let .checkValidNickname(nickname):
            return "users/check-duplicate-nickname/\(nickname)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUser:
            return .get
        case .setNickname:
            return .patch
        case .checkValidNickname:
            return .get
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getUser:
            return .query(nil)
        case let .setNickname(nickname):
            return .body(["nickname": nickname])
        case .checkValidNickname:
            return .query(nil)
        }
    }
}

