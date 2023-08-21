//
//  AppCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/25.
//

import UIKit
import Combine

final class AppCoordinator: BaseWindowCoordinator<AppStep> {
    override func start() {
        
        
        navigator.window.rootViewController = SplashViewController()
        navigator.makeKeyAndVisible()
        
        //authentication
        Task {
            await Authentication.shared.showLoginScene()
        }
    }
    
    override func navigate(to step: AppStep) {
        switch step {
        case .login:
            showLogin()
        case .main:
            showMain()
        }
    }
    
    private func showLogin() {
        let loginNavigationController = BaseNavigationController()
        let loginStackNavigator = StackNavigator(rootViewController: loginNavigationController)
        let loginCoordinator = LoginCoordinator(navigator: loginStackNavigator)
        add(coordinators: loginCoordinator)
        navigator.window.rootViewController = loginNavigationController
        loginCoordinator.start()
        UIView.transition(with: navigator.window, duration: 0.3, options: .transitionCrossDissolve, animations: {}, completion: { _ in })
    }
    
    private func showMain() {
        
    }
}

