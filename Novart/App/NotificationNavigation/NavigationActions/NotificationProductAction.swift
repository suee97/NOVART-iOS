//
//  NotificationProductAction.swift
//  Novart
//
//  Created by Jinwook Huh on 3/22/24.
//

import Foundation

struct NotificationProductAction: NotificationNavigationExecutable {
    var notification: NotificationModel
    
    init(notification: NotificationModel) {
        self.notification = notification
    }
    
    @MainActor
    func execute(to coordinator: (any Coordinator)?, asPush: Bool) -> Bool {
        guard let productId = notification.artId else {
            return false
        }
        
        switch asPush {
        case true:
            guard let coordinator = coordinator as? MyPageCoordinator else {
                return false
            }
            coordinator.navigate(to: .product(Int64(productId)))
            
        case false:
            guard let appCoordinator = coordinator as? AppCoordinator else {
                return false
            }
            
            for childCoordinator in appCoordinator.childCoordinators {
                childCoordinator.end()
            }
            appCoordinator.navigate(to: .main)
            guard let mainCoordinator = appCoordinator.childCoordinators.first(where: { $0 is MainCoordinator }) as? MainCoordinator else { return false }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showProductDetail(mainCoordinator: mainCoordinator, productId: Int64(productId))
            }
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
