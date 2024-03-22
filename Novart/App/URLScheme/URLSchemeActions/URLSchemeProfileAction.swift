//
//  URLSchemeProfileAction.swift
//  Novart
//
//  Created by Jinwook Huh on 3/10/24.
//

import Foundation

struct URLSchemeProfileAction: URLSchemeExecutable {
    
    var url: URL?
    
    @MainActor
    func execute(to coordinator: (any Coordinator)?) -> Bool {
        guard let url = self.url,
              let profileId = Int64(url.lastPathComponent),
              let appCoordinator = coordinator as? AppCoordinator
        else { return false }
        
        for childCoordinator in appCoordinator.childCoordinators {
            childCoordinator.end()
        }
        appCoordinator.navigate(to: .main)
        guard let mainCoordinator = appCoordinator.childCoordinators.first(where: { $0 is MainCoordinator }) as? MainCoordinator else { return false }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            showProfile(mainCoordinator: mainCoordinator, profileId: profileId)
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
