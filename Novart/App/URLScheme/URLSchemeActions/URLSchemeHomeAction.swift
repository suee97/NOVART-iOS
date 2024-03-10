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
        guard let url = self.url,
              let appCoordinator = coordinator as? AppCoordinator
        else { return false }
        
        appCoordinator.navigate(to: .main)
        return true
    }
}
