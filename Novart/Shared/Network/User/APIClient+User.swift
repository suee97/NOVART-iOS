//
//  APIClient+User.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/22.
//

import Alamofire
import Foundation

extension APIClient {
    static func getUser() async throws -> NetworkResponse<NovartUser> {
        try await APIClient.request(target: UserTarget.getUser, type: NetworkResponse<NovartUser>.self)
    }
    
    static func setNickname(as nickname: String) async throws -> NetworkResponse<SetNameResponse> {
        try await APIClient.request(target: UserTarget.setNickname(nickname: nickname), type: NetworkResponse<SetNameResponse>.self)
    }
}

