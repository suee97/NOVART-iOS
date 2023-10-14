//
//  UserInteractor.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/11.
//

import Foundation

final class UserInteractor {
    func getUserInfo() async throws -> PlainUser {
        let user = try await APIClient.getUser()
        Authentication.shared.user = user
        return user
    }
    
    func checkIsValidNickname(nickname: String) async throws -> Bool {
        let isValid = try await APIClient.checkValidNickname(nickname: nickname)
        return isValid
    }
}
