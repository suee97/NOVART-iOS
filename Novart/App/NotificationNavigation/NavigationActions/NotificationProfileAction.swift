//
//  NotificationProfileAction.swift
//  Novart
//
//  Created by Jinwook Huh on 3/22/24.
//

import Foundation

struct NotificationProfileAction: NotificationNavigationExecutable {
    var notification: NotificationModel
    
    init(notification: NotificationModel) {
        self.notification = notification
    }
    
    @MainActor
    func execute(to coordinator: (any Coordinator)?, asPush: Bool) -> Bool {
        guard let profileId = notification.senderId else {
            return false
        }
        
        switch asPush {
        case true:
            guard let coordinator = coordinator as? MyPageCoordinator else {
                return false
            }
            coordinator.navigate(to: .artist(Int64(profileId)))
            
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
                showProfile(mainCoordinator: mainCoordinator, profileId: Int64(profileId))
            }
        }
        return true
    }
    
    @MainActor
    private func showProfile(mainCoordinator: MainCoordinator, profileId: Int64) {
        mainCoordinator.selectTab(index: 3)
        let myPageCoordinator: MyPageCoordinator? = mainCoordinator.childCoordinators.first(where: { $0 is MyPageCoordinator}) as? MyPageCoordinator
        myPageCoordinator?.navigate(to: .artist(profileId))
    }
}
