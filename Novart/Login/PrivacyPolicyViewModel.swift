//
//  PrivacyPolicyViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/22.
//

import Foundation

final class PrivacyPolicyViewModel {
    private weak var coordinator: LoginCoordinator?

    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }
    
    @MainActor
    func transitionToMainScene() {
        coordinator?.navigate(to: .main)
    }
}
