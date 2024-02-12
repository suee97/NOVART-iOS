//
//  LoginCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/02.
//

import UIKit

final class LoginCoordinator: BaseStackCoordinator<LoginStep> {
    override func start() {
        let viewModel = LoginViewModel(coordinator: self)
        let loginViewController = LoginViewController(viewModel: viewModel)
        navigator.start(loginViewController)
    }
    
    override func navigate(to step: LoginStep) {
        switch step {
        case .main:
            showMain()
        case .policy:
            showPrivacyPolicyViewController()
        }
    }
    
    private func showMain() {
        guard let window = UIApplication.shared.keyWindowScene else { return }
        let windowNavigator = WindowNavigator(window: window)
        let mainCoordinator = MainCoordinator(windowNavigator: windowNavigator)
        add(coordinators: mainCoordinator)
        
        mainCoordinator.start()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {}, completion: { _ in})
    }
    
    @MainActor
    private func showPrivacyPolicyViewController() {
        let viewModel = PrivacyPolicyViewModel(coordinator: self)
        let viewController = PrivacyPolicyViewController(viewModel: viewModel)
        navigator.push(viewController, animated: true)
    }
}
