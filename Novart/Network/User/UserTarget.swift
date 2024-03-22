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
    case putDeviceToken(deviceToken: String)
    
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
        case .putDeviceToken:
            return "users/me/fcm-device-token"
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
        case .putDeviceToken:
            return .put
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
        case let .putDeviceToken(deviceToken):
            return .body(["deviceToken": deviceToken])
        }
    }
}

