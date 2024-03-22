//
//  AppCoordinator+Action.swift
//  Novart
//
//  Created by Jinwook Huh on 3/9/24.
//

import UIKit

extension AppCoordinator {
    
    // MARK: - Scheme
    
    @MainActor
    func handleScheme(_ url: URL) {
        guard let coordinator = UIApplication.shared.appCoordinator else { return }
        URLSchemeHandler(coordinator: coordinator).execute(url: url)
    }
}
