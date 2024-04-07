//
//  LoginModalPresentableCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 3/26/24.
//

import UIKit

protocol LoginModalPresentableCoordinator: Coordinator where Navigator == StackNavigator {
    
    @MainActor
    func presentLoginModal()
}

extension LoginModalPresentableCoordinator {
    
    @MainActor
    func presentLoginModal() {
        let bottomSheetRoot = BottomSheetNavigationController()
        bottomSheetRoot.bottomSheetConfiguration.customHeight = UIScreen.main.bounds.height - 132
        let stackNavigator = StackNavigator(rootViewController: bottomSheetRoot, presenter: navigator.rootViewController)
        let loginCoordinator = LoginCoordinator(navigator: stackNavigator)
        add(coordinators: loginCoordinator)
        loginCoordinator.startAsModal()
    }
}
