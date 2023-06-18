//
//  PolicyArgreeView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/18.
//

import SwiftUI

struct PolicyArgreeView: View {
    
    @ObservedObject private var viewModel = PolicyAgreeViewModel()
    @State private var shouldShowNicknameView = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 32)
            HStack {
                Text("NOVART 서비스에 대한\n약관동의가 필요해요.")
                    .foregroundColor(Color.Common.primaryDarkTextColor)
                    .font(.system(size: 20, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
                Spacer()
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
                            Text("마케팅 정보 수신 동의")
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
                        viewModel.signup()
                    } label: {
                        Text("완료")
                            .foregroundColor(Color.Common.white)
                            .font(.system(size: 16, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 46)
                            .background(viewModel.enableNext ? Color.Common.primaryTintColor : Color.Common.gray01)
                            .cornerRadius(4)
                    }
                    .buttonStyle(NoHighlightButtonStyle())
                    .disabled(!viewModel.enableNext)

                }
        
            }
            
            Spacer()
                .frame(height: 22)
            
        }
        .padding([.leading, .trailing], 24)
        .onChange(of: viewModel.isSignupSuccess) { success in
            if success {
                shouldShowNicknameView = true
            }
        }
        .background(
            NavigationLink("", destination: SetNameView(), isActive: $shouldShowNicknameView).opacity(0)
        )
    }
}

extension PolicyArgreeView {
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
}

struct PolicyArgreeView_Previews: PreviewProvider {
    static var previews: some View {
        PolicyArgreeView()
    }
}
