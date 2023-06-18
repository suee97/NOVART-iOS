//
//  AuthProperties.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/07.
//

import Foundation

final class AuthProperties {
    
    static let shared: AuthProperties = AuthProperties()
    
    var isInitialSignUp: Bool = true
    var signInProvider: SignInProvider?
    var providerAccessToken: String?
    var user: UserDTO?
}
