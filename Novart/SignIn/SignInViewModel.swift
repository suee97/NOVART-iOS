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
    
    @Published var signInResult: Bool = false
    
    var interactor: SignInInteractor = SignInInteractor()
    
    init(){
    }

    
    func signIn(with type: SignInProvider){
        
        switch type {
        case .kakao:
            Task { @MainActor in
                do {
                    let authToken = try await interactor.performKakaoSignIn()
                    let accessToken = authToken.accessToken
                    try await interactor.signInToServer(accessToken: accessToken, provider: .kakao)
                    signInResult = true
                } catch {
                    signInResult = false
                }
            }
        case .google:
            Task { @MainActor in
                do {
                    let result = try await interactor.performGoogleSignIn()
                    let accessToken = result.user.accessToken.tokenString
                    try await interactor.signInToServer(accessToken: accessToken, provider: .google)
                    signInResult = true
                } catch {
                    print(error)
                    signInResult = false
                }
            }

        }
    }
    
    private func signInWithGoogle() async throws -> (String?, String?) {
        let result = try await interactor.performGoogleSignIn()
        return (result.user.profile?.email, result.user.userID)
    }
    
    func signOut(){
        GIDSignIn.sharedInstance.signOut()
    }
}
