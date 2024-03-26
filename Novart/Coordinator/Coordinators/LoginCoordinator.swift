//
//  LoginCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/02.
//

import UIKit

final class LoginCoordinator: BaseStackCoordinator<LoginStep> {
    
    private var isPresentedAsModal: Bool = false
    
    override func start() {
        super.start()
        let viewModel = LoginViewModel(coordinator: self)
        let loginViewController = LoginViewController(viewModel: viewModel)
        navigator.start(loginViewController)
    }
    
    @MainActor
    func startAsModal() {
        super.start()
        let viewModel = LoginViewModel(coordinator: self)
        isPresentedAsModal = true
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
    
    @MainActor
    private func showMain() {
        if isPresentedAsModal {
            close {
                guard let appCoordinator = UIApplication.shared.appCoordinator else {
                    return
                }
                
                for childCoordinator in appCoordinator.childCoordinators {
                    childCoordinator.end()
                }
                
                DispatchQueue.main.async {
                    appCoordinator.navigate(to: .main)
                }
            }
        } else {
            guard let window = UIApplication.shared.keyWindowScene else { return }
            let windowNavigator = WindowNavigator(window: window)
            let mainCoordinator = MainCoordinator(windowNavigator: windowNavigator)
            parentCoordinator?.add(coordinators: mainCoordinator)
            
            mainCoordinator.start()
            
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {}, completion: { _ in})
            end()
        }
    }
    
    @MainActor
    private func showPrivacyPolicyViewController() {
        let viewModel = PrivacyPolicyViewModel(coordinator: self)
        let viewController = PrivacyPolicyViewController(viewModel: viewModel)
        navigator.push(viewController, animated: true)
    }
}
