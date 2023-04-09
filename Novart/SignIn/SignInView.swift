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
        VStack(alignment: .center) {
            Spacer()
                .frame(height: 144)
            
            // top logo
            Group {
                Image("sign_in_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.leading, 84)
                    .padding(.trailing, 84)
                Spacer()
                    .frame(height: 32)
                Text("'예술작품부터 인테리어까지! 종합 중개 플랫폼'")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color.white)
            }
            Spacer()
            
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
                SignInButtonStack()
                Spacer()
                    .frame(height: 16)
                Button {
                    print("login")
                } label: {
                    Text("로그인하지 않고 둘러보기")
                        .font(.system(size: 14))
                        .underline()
                        .foregroundColor(Color.white)
                }
                .buttonStyle(NoHighlightButtonStyle())
            }
            Spacer()
                .frame(height: 131)
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Common.primaryTintColor)
    }
}

struct SignInButtonStack: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            KakaoSignInButton()
            GoogleSignInButton()
            AppleSignInButton()
        }
        .padding(.leading, 24)
        .padding(.trailing, 24)
    }
}

struct KakaoSignInButton: View {
    var body: some View {
        Button {
            print("apple")
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
}

struct GoogleSignInButton: View {
    var body: some View {
        Button {
            print("google")
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
}

struct AppleSignInButton: View {
    var body: some View {
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel())
    }
}
