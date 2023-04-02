//
//  NovartApp.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/01.
//

import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKCommon
import SwiftUI

@main
struct NovartApp: App {
    
    init() {
        configureKakaoSignIn()
        configureGoogleSignIn()
    }
    
    var body: some Scene {
        WindowGroup {
            SignInView(viewModel: SignInViewModel())
                .onOpenURL { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
    
    private func configureKakaoSignIn() {
        KakaoSDK.initSDK(appKey: "4c764881505c7f1c4fc42bff687e9d79")
    }
    
    private func configureGoogleSignIn() {
        let signInConfig = GIDConfiguration.init(clientID: "937960757565-2verfe9hqvo4jrkfo9oenuukqtatpt7b.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.configuration = signInConfig
    }
}
