//
//  APIClient+User.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/22.
//

import Alamofire
import Foundation

extension APIClient {
    static func getUser() async throws -> PlainUser {
        try await APIClient.request(target: UserTarget.getUser, type: PlainUser.self)
    }
    
    static func setNickname(as nickname: String) async throws -> NetworkResponse<SetNameResponse> {
        try await APIClient.request(target: UserTarget.setNickname(nickname: nickname), type: NetworkResponse<SetNameResponse>.self)
    }
    
    static func checkValidNickname(nickname: String) async throws -> Bool {
        try await APIClient.request(target: UserTarget.checkValidNickname(nickname: nickname), type: Bool.self)
    }
    
    static func putDeviceToken(deviceToken: String) async throws -> EmptyResponseModel {
        try await APIClient.request(target: UserTarget.putDeviceToken(deviceToken: deviceToken), type: EmptyResponseModel.self)
    }
}
