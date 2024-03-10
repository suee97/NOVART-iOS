//
//  URLSchemeProductAction.swift
//  Novart
//
//  Created by Jinwook Huh on 3/10/24.
//

import Foundation

struct URLSchemeProductAction: URLSchemeExecutable {
    
    var url: URL?
    
    @MainActor
    func execute(to coordinator: (any Coordinator)?) -> Bool {
        guard let url = self.url,
              let productId = Int64(url.lastPathComponent),
              let appCoordinator = coordinator as? AppCoordinator
        else { return false }
        
        var mainCoordinator: MainCoordinator?
        mainCoordinator = appCoordinator.childCoordinators.first(where: { $0 is MainCoordinator }) as? MainCoordinator
        
        if let mainCoordinator {
            showProductDetail(mainCoordinator: mainCoordinator, productId: productId)
        } else {
            appCoordinator.navigate(to: .main)
            guard let mainCoordinator = appCoordinator.childCoordinators.first(where: { $0 is MainCoordinator }) as? MainCoordinator else { return false }
            showProductDetail(mainCoordinator: mainCoordinator, productId: productId)
        }
        return true
    }
    
    @MainActor
    private func showProductDetail(mainCoordinator: MainCoordinator, productId: Int64) {
        mainCoordinator.selectTab(index: 0)
        let homeCoordinator: HomeCoordinator? = mainCoordinator.childCoordinators.first(where: { $0 is HomeCoordinator}) as? HomeCoordinator
        homeCoordinator?.navigate(to: .productDetail(id: productId))
    }
}

