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
    @State private var shouldShowSetNicknameView = false
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
                .frame(height: 174)
            
            // top logo
            Group {
                Image("sign_in_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.leading, 84)
                    .padding(.trailing, 84)
                Spacer()
                    .frame(height: 40)
                
                Text("나만의 새로운 작품")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color.white)
                
                Spacer()
                    .frame(height: 16)
                
                Text("예술작품 중개 플랫폼\n예술작품에서 인테리어까지!")
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color.white)
            }
            Spacer()
                .frame(height: 56)
            
            // bottom buttons
            Group {
                HStack(spacing: 8) {
                    Rectangle()
                        .foregroundColor(Color(hex: "F8F8F8"))
                        .frame(height: 1)
                    Text("로그인")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color.white)
                    Rectangle()
                        .foregroundColor(Color(hex: "F8F8F8"))
                        .frame(height: 1)
                }
                .padding(.leading, 24)
                .padding(.trailing, 24)
                Spacer()
                    .frame(height: 24)
                signInButtonStack
                Spacer()
                    .frame(height: 16)
                Button {
                    transitionToMainTabView()
                } label: {
                    Text("로그인하지 않고 둘러보기")
                        .font(.system(size: 14))
                        .underline()
                        .foregroundColor(Color.white)
                }
                .buttonStyle(NoHighlightButtonStyle())
            }
            Spacer()
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Common.primaryTintColor)
        .onChange(of: viewModel.signInResult) { success in
            guard success else { return }
            if AuthProperties.shared.isInitialSignUp {
                shouldShowSetNicknameView = true
            } else {
                transitionToMainTabView()
            }
        }
        .navigationBarHidden(true)
        .background(
            NavigationLink("", destination: SetNameView(), isActive: $shouldShowSetNicknameView).opacity(0)
        )
    }
    
    
    
    var kakaoSignInButton: some View {
        Button {
            viewModel.signIn(with: .kakao)
        } label: {
            ZStack {
                HStack {
                    Spacer()
                    Text("카카오로 계속하기")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(hex: "333333"))
                    Spacer()
                }
                .frame(height: 50)
                .background(Color(hex: "F9DF4A"))
                HStack {
                    Spacer()
                        .frame(width: 15)
                    Image("kakao_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                    Spacer()
                }
            }
        }
        .buttonStyle(NoHighlightButtonStyle())
    }
    
    var googleSignInButton: some View {
        Button {
            viewModel.signIn(with: .google)
        } label: {
            ZStack {
                HStack {
                    Spacer()
                    Text("구글로 계속하기")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color.black)
                    Spacer()
                }
                .frame(height: 50)
                .background(Color.white)
                HStack {
                    Spacer()
                        .frame(width: 15)
                    Image("google_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18, height: 18)
                    Spacer()
                }
            }
        }
        .buttonStyle(NoHighlightButtonStyle())
    }
    
    var appleSignInButton: some View {
        Button {
            print("apple")
        } label: {
            ZStack {
                HStack {
                    Spacer()
                    Text("애플로 계속하기")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color.white)
                    Spacer()
                }
                .frame(height: 50)
                .background(Color.black)
                HStack {
                    Spacer()
                        .frame(width: 15)
                    Image("apple_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18, height: 18)
                    Spacer()
                }
            }
        }
        .buttonStyle(NoHighlightButtonStyle())
    }
    
    var signInButtonStack: some View {
        VStack(alignment: .center, spacing: 8) {
            kakaoSignInButton
            googleSignInButton
            appleSignInButton
        }
        .padding(.leading, 24)
        .padding(.trailing, 24)
    }
    
}

extension SignInView {
    private func transitionToMainTabView() {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.2
        window.layer.add(transition, forKey: kCATransition)
        
        window.rootViewController = UIHostingController(rootView: MainTabView())
        window.makeKeyAndVisible()
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel())
    }
}
