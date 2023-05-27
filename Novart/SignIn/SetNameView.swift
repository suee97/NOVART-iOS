//
//  SetNameView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/07.
//

import SwiftUI

struct SetNameView: View {
    @ObservedObject var viewModel = SetNameViewModel()
    
    @State private var nickname = AuthProperties.shared.user?.nickname ?? "활동할 닉네임을 만들어보세요!"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
                .frame(height: 24)
            HStack {
                Spacer()
                Button {
                    viewModel.setNickname(as: nickname)
                    transitionToMainTabView()
                } label: {
                    Text("건너뛰기")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white)
                }

            }
            
            Spacer()
                .frame(height: 200)
            
            Text("닉네임")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
                .frame(height: 24)
            
            TextField("", text: $nickname)
                .font(.system(size: 14, weight: .regular))
                .background(Color.clear)
                .foregroundColor(.white)
                .cornerRadius(4)
                .padding([.top, .bottom], 10)
                .padding([.leading, .trailing], 12)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.white, lineWidth: 1)
                )
            
            Spacer()
                .frame(height: 8)
            
            HStack {
                Spacer()
                Text("\(nickname.count)/15자")
                    .font(.system(size: 12, weight: .regular))
            }
            Spacer()
        }
        .padding([.leading, .trailing], 24)
        .background(Color.Common.primaryTintColor)
        .navigationBarHidden(true)
    }
}

extension SetNameView {
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


struct SetNameView_Previews: PreviewProvider {
    static var previews: some View {
        SetNameView()
    }
}
