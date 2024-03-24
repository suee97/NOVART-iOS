//
//  NotificationNavigationHandler.swift
//  Novart
//
//  Created by Jinwook Huh on 3/22/24.
//

import Foundation

@MainActor
final class NotificationNavigationHandler {
    private weak var coordinator: (any Coordinator)?
    
    init(coordinator: (any Coordinator)? = nil) {
        self.coordinator = coordinator
    }
    
    @discardableResult
    func execute(notification: NotificationModel) -> Bool {
        if let coordinator = coordinator as? MyPageCoordinator {
            return NotificationNavigationFactory.create(notification: notification)?.execute(to: coordinator, asPush: true) ?? false
        } else if let coordinator = coordinator as? AppCoordinator {
            return NotificationNavigationFactory.create(notification: notification)?.execute(to: coordinator, asPush: false) ?? false
        } else {
            return false
        }
    }
}
