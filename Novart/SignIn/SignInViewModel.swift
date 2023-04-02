//
//  SignInViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/02.
//

import SwiftUI
import GoogleSignIn

enum SignInType {
    case kakao
    case google
}

class SignInViewModel: ObservableObject {
    
    @Published var email: String? = ""
    @Published var userID: String? = ""
    
    var interactor: SignInInteractor = SignInInteractor()
    
    init(){
    }

    
    func signIn(with type: SignInType){
        
        switch type {
        case .kakao:
            Task { @MainActor in
                do {
                    let user = try await interactor.performKakaoSignIn()
                    self.email = user.kakaoAccount?.email
                    self.userID = "\(user.id ?? 0)"
                } catch {
                    
                }
            }
        case .google:
            Task { @MainActor in
                do {
                    let result = try await interactor.performGoogleSignIn()
                    self.email = result.user.profile?.email
                    self.userID = result.user.userID
                } catch {
                    print(error)
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
