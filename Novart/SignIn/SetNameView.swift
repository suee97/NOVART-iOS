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
            Spacer()
                .frame(height: 190)
            
            Group {
                Text("닉네임")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.Common.primaryTintColor)
                
                Spacer()
                    .frame(height: 4)
                
                HStack(alignment: .bottom) {
                    Text("자동생성된 닉네임이에요. 자유롭게 바꿀 수 있어요.")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color.Common.gray02)
                    
                    Spacer()
                    
                    Button {
                        print("중복확인")
                    } label: {
                        Text("중복확인")
                            .foregroundColor(Color.Common.gray03)
                            .font(.system(size: 14, weight: .regular))
                            .padding([.leading, .trailing], 10)
                            .padding([.top, .bottom], 8)
                            .background(Color.Common.gray00)
                            .foregroundColor(Color.white)
                            .cornerRadius(4)
                    }
                    .buttonStyle(NoHighlightButtonStyle())
                    
                }
                
                Spacer()
                    .frame(height: 12)
                
                TextField("", text: $viewModel.nickname)
                    .font(.system(size: 14, weight: .regular))
                    .background(Color.clear)
                    .foregroundColor(Color.Common.gray03)
                    .cornerRadius(4)
                    .padding([.top, .bottom], 10)
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
                
                Spacer()
                    .frame(height: 8)
                
                HStack {
                    Spacer()
                    Text("\(viewModel.nickname.count)/15자")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color.Common.gray03)
                }
            }
            Spacer()
            
            Group {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("모두 동의")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color.Common.primaryDarkTextColor)
                        
                        Spacer()
                        
                        Button {
                            viewModel.isAllAgree.toggle()
                            toggleAllBoxes(as: viewModel.isAllAgree)
                        } label: {
                            if viewModel.isAllAgree {
                                Image("checkmark_fill")
                            } else {
                                Image("checkmark_empty")
                            }
                            
                        }
                        .buttonStyle(NoHighlightButtonStyle())
                    }
                    .cornerRadius(4)
                    .padding([.top, .bottom], 12)
                    .padding([.leading, .trailing], 12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.Common.gray01, lineWidth: 1)
                    )
                    .background(Color.Common.white)
                    
                    Spacer()
                        .frame(height: 14)
                    
                    HStack(spacing: 4) {
                        
                        Button {
                            print("서비스 이용약관 동의 보기")
                        } label: {
                            Text("서비스 이용 약관 동의")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(Color.Common.wireDarkGray)
                                .underline()
                        }
                        .buttonStyle(NoHighlightButtonStyle())

                        
                        Text("(필수)")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color.Common.sub)
                        
                        Spacer()
                        
                        Button {
                            viewModel.isServiceAgree.toggle()
                            if !viewModel.isServiceAgree {
                                viewModel.isAllAgree = false
                            }
                        } label: {
                            if viewModel.isServiceAgree {
                                Image("checkmark_fill")
                            } else {
                                Image("checkmark_empty")
                            }
                            
                        }
                        .buttonStyle(NoHighlightButtonStyle())

                    }
                    .padding([.leading, .trailing], 12)
                    
                    Spacer()
                        .frame(height: 14)
                    
                    HStack(spacing: 4) {
                        
                        Button {
                            print("개인 정보 수집 및 이용 동의 보기")
                        } label: {
                            Text("개인 정보 수집 및 이용 동의")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Color.Common.wireDarkGray)
                                .underline()
                        }
                        .buttonStyle(NoHighlightButtonStyle())

                        
                        Text("(필수)")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color.Common.sub)
                        
                        Spacer()
                        
                        Button {
                            viewModel.isPrivacyAgree.toggle()
                            if !viewModel.isPrivacyAgree {
                                viewModel.isAllAgree = false
                            }
                        } label: {
                            if viewModel.isPrivacyAgree {
                                Image("checkmark_fill")
                            } else {
                                Image("checkmark_empty")
                            }
                            
                        }
                        .buttonStyle(NoHighlightButtonStyle())

                    }
                    .padding([.leading, .trailing], 12)
                    
                    
                    Spacer()
                        .frame(height: 14)
                    
                    HStack(spacing: 4) {
                        
                        Button {
                            print("마케팅 수신, 홍보 목적의 개인정보 수집 및 이용 동의보기")
                        } label: {
                            Text("마케팅 수신, 홍보 목적의 개인정보 수집 및 이용 동의")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(Color.Common.wireDarkGray)
                                .underline()
                                .lineLimit(1)
                            
                        }
                        .buttonStyle(NoHighlightButtonStyle())

                        Text("(선택)")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color.Common.wireDarkGray)
                        
                        Spacer()
                        
                        Button {
                            viewModel.isMarketingAgree.toggle()
                            if !viewModel.isMarketingAgree {
                                viewModel.isAllAgree = false
                            }
                        } label: {
                            if viewModel.isMarketingAgree {
                                Image("checkmark_fill")
                            } else {
                                Image("checkmark_empty")
                            }
                            
                        }
                        .buttonStyle(NoHighlightButtonStyle())

                    }
                    .padding([.leading, .trailing], 12)
                    
                    Spacer()
                        .frame(height: 70)
                    
                    Button {
                        viewModel.setNickname()
                    } label: {
                        Text("완료")
                            .foregroundColor(Color.Common.white)
                            .font(.system(size: 16, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 46)
                            .background(Color.Common.gray01)
                            .cornerRadius(4)
                    }
                    .buttonStyle(NoHighlightButtonStyle())
                    .disabled(!viewModel.enableDone)

                }
        
            }
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
