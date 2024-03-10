//
//  URLSchemeHomeAction.swift
//  Novart
//
//  Created by Jinwook Huh on 3/10/24.
//

import Foundation

struct URLSchemeHomeAction: URLSchemeExecutable {
    
    var url: URL?
    
    @MainActor
    func execute(to coordinator: (any Coordinator)?) -> Bool {
        guard url != nil,
              let appCoordinator = coordinator as? AppCoordinator
        else { return false }
        for childCoordinator in appCoordinator.childCoordinators {
            childCoordinator.end()
        }
        appCoordinator.navigate(to: .main)
        return true
    }
}
