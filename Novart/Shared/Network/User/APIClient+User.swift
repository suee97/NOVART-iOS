//
//  APIClient+User.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/07.
//

import Alamofire
import Foundation

extension APIClient {
    static func getUser() async throws -> UserResponse {
        try await APIClient.request(target: UserTarget.getUser, type: UserResponse.self)
    }
    
    static func setNickname(as nickname: String) async throws -> SetNameResponse {
        try await APIClient.request(target: UserTarget.setNickname(nickname: nickname), type: SetNameResponse.self)
    }
}

