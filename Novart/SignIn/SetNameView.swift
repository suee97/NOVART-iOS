//
//  SetNameView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/07.
//

import SwiftUI

struct SetNameView: View {
    @ObservedObject var viewModel = SetNameViewModel()
        
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
           
            Group {
                Spacer()
                    .frame(height: 96)
               
                HStack {
                    Text("NOVART에서 활동할\n닉네임을 만들어주세요.")
                        .foregroundColor(Color.Common.primaryDarkTextColor)
                        .font(.system(size: 20, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .lineSpacing(4)
                    Spacer()
                }
                
                Spacer()
                    .frame(height: 16)
                
                Text("해당 닉네임은 자동 생성된 닉네임이에요.\n자유롭게 바꿀 수 있어요.")
                    .foregroundColor(Color.Common.gray02)
                    .font(.system(size: 12, weight: .regular))
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
                .frame(height: 56)
            
            Group {

                HStack(alignment: .top, spacing: 8) {

                    VStack(alignment: .trailing, spacing: 8) {
                        TextField(AuthProperties.shared.user?.nickname ?? "", text: $viewModel.nickname)
                            .font(.system(size: 14, weight: .regular))
                            .background(Color.clear)
                            .foregroundColor(Color.Common.gray03)
                            .cornerRadius(4)
                            .padding([.top, .bottom], 11)
                            .padding([.leading, .trailing], 12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.Common.subtextColor, lineWidth: 1)
                            )
                            .onChange(of: viewModel.nickname) { newValue in
                                if newValue.count > viewModel.maxNicknameLength {
                                    viewModel.nickname = String(newValue.prefix(viewModel.maxNicknameLength))
                                }
                            }
                        
                        Text("\(viewModel.nickname.count)/15자")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color.Common.gray03)
                    }
   
                    
                    Button {
                        print("중복확인")
                    } label: {
                        Text("중복확인")
                            .frame(height: 42)
                            .foregroundColor(Color.Common.gray03)
                            .font(.system(size: 14, weight: .regular))
                            .padding([.leading, .trailing], 10)
                            .background(Color.Common.gray00)
                            .foregroundColor(Color.white)
                            .cornerRadius(4)
                    }
                    .buttonStyle(NoHighlightButtonStyle())
                    
                }
            }
            Spacer()
            
            Button {
                viewModel.setNickname()
            } label: {
                Text("완료")
                    .foregroundColor(Color.Common.white)
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .background(Color.Common.primaryTintColor)
                    .cornerRadius(4)
            }
            .buttonStyle(NoHighlightButtonStyle())
//            .disabled(!viewModel.enableNext)
            
            Spacer()
                .frame(height: 22)
        }
        .padding([.leading, .trailing], 24)
        .navigationBarHidden(true)
        .onChange(of: viewModel.setNameSuccess) { success in
            if success {
                transitionToMainTabView()
            }
        }
    }
}

extension SetNameView {
    private func toggleAllBoxes(as check: Bool) {
        if check {
            viewModel.isMarketingAgree = true
            viewModel.isServiceAgree = true
            viewModel.isPrivacyAgree = true
        } else {
            viewModel.isMarketingAgree = false
            viewModel.isServiceAgree = false
            viewModel.isPrivacyAgree = false
        }
    }
    
    private func transitionToMainTabView() {
        
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.2
        window.layer.add(transition, forKey: kCATransition)
        
        window.rootViewController = UIHostingController(rootView: MainTabView())
        window.makeKeyAndVisible()
    }
}


struct SetNameView_Previews: PreviewProvider {
    static var previews: some View {
        SetNameView()
    }
}
