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
            await Authentication.shared.login()
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
    
    @MainActor
    private func showLogin() {
        let loginNavigationController = BaseNavigationController()
        let loginStackNavigator = StackNavigator(rootViewController: loginNavigationController)
        let loginCoordinator = LoginCoordinator(navigator: loginStackNavigator)
        add(coordinators: loginCoordinator)
        navigator.window.rootViewController = loginNavigationController
        loginCoordinator.start()
        UIView.transition(with: navigator.window, duration: 0.3, options: .transitionCrossDissolve, animations: {}, completion: { _ in })
    }
    
    @MainActor
    private func showMain() {
        guard let window = UIApplication.shared.keyWindowScene else { return }
        let windowNavigator = WindowNavigator(window: window)
        let mainCoordinator = MainCoordinator(windowNavigator: windowNavigator)
        add(coordinators: mainCoordinator)
        
        mainCoordinator.start()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {}, completion: { _ in})
    }
}

