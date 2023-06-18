//
//  SplashView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/18.
//

import SwiftUI

struct SplashView: View {
    
    @ObservedObject private var viewModel: SplashViewModel = SplashViewModel()
    
    var body: some View {
        
        VStack {
            Image("sign_in_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.leading, 84)
                .padding(.trailing, 84)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Common.primaryTintColor)
        .onAppear {
            viewModel.login()
        }
        .onReceive(viewModel.isLoginSuccess) { success in
            if success {
                transitionToMainTabView()
            } else {
                transitionToSignInView()
            }
        }

    }

}

extension SplashView {
    private func transitionToMainTabView() {
        
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.2
        window.layer.add(transition, forKey: kCATransition)

        window.rootViewController = UIHostingController(rootView: MainTabView())
        window.makeKeyAndVisible()
    }
    
    private func transitionToSignInView() {
        
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.2
        window.layer.add(transition, forKey: kCATransition)
        
        let rootView = NavigationView {
            SignInView(viewModel: SignInViewModel())
        }
        window.rootViewController = UIHostingController(rootView: rootView)
        window.makeKeyAndVisible()
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
