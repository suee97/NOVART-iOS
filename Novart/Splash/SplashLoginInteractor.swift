//
//  SplashLoginInteractor.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/18.
//

import Foundation

final class SplashLoginInteractor {
    
    func loginIfUserExists() async throws -> Bool {
        if KeychainService.shared.accessToken != nil {
            try await getUserInfo()
            return true
        } else  {
            return false
        }
    }
    
    private func getUserInfo() async throws {
        let userResponse = try await APIClient.getUser()
        let user = userResponse.data
        AuthProperties.shared.user = user
    }
}
