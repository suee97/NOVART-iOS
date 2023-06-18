//
//  SignInViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/02.
//

import Combine
import SwiftUI
import GoogleSignIn

class SignInViewModel: ObservableObject {
    
    var isFirstLogin: PassthroughSubject<Bool, Never> = PassthroughSubject<Bool, Never>()
    var interactor: LoginInteractor = LoginInteractor()
    
    init(){
    }

    func login(with type: SignInProvider) {
        switch type {
        case .kakao:
            Task {
                do {
                    let authToken = try await interactor.performKakaoSignIn()
                    let isFirst = try await interactor.login(accessToken: authToken.accessToken, provider: .kakao)
                    DispatchQueue.main.async { [weak self] in
                        self?.isFirstLogin.send(isFirst)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        case .google:
            Task {
                do {
                    let accessToken = try await interactor.performGoogleSignIn()
                    let isFirst = try await interactor.login(accessToken: accessToken, provider: .google)
                    DispatchQueue.main.async {
                        DispatchQueue.main.async { [weak self] in
                            self?.isFirstLogin.send(isFirst)
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func signOut(){
        GIDSignIn.sharedInstance.signOut()
    }
}
