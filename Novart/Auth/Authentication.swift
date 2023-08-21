//
//  Authentication.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/02.
//

import UIKit

final class Authentication {
    
    static let shared: Authentication = Authentication()
    
    var signInProvider: SignInProvider?
    var providerAccessToken: String?
    var user: NovartUser?
}


extension Authentication {
    func login() {
    }
    
    func showLoginScene() async {
        await UIApplication.shared.appCoordinator?.navigate(to: .login)
    }
}
