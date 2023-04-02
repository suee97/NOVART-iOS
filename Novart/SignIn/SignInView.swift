//
//  SignInView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/01.
//

import KakaoSDKUser
import GoogleSignIn
import GoogleSignInSwift
import SwiftUI

struct SignInView: View {
    
    @ObservedObject var viewModel: SignInViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            HStack {
                Text("email: ")
                Text(viewModel.email ?? "")
                Spacer()
            }
            HStack {
                Text("userID:")
                Text(viewModel.userID ?? "")
                Spacer()
            }
            Spacer()
                .frame(height: 16)
            Button("카카오 로그인") {
                viewModel.signIn(with: .kakao)
            }
            
            Button("구글 로그인") {
                viewModel.signIn(with: .google)
            }
        }
        .frame(width: 280)
        .font(.system(size: 16))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel())
    }
}
