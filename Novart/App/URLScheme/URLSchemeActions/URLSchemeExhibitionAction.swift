//
//  URLSchemeExhibitionAction.swift
//  Novart
//
//  Created by Jinwook Huh on 3/10/24.
//

import Foundation

struct URLSchemeExhibitionAction: URLSchemeExecutable {
    
    var url: URL?
    
    @MainActor
    func execute(to coordinator: (any Coordinator)?) -> Bool {
        guard let url = self.url,
              let exhibitionId = Int64(url.lastPathComponent),
              let appCoordinator = coordinator as? AppCoordinator
        else { return false }
        
        for childCoordinator in appCoordinator.childCoordinators {
            childCoordinator.end()
        }
        appCoordinator.navigate(to: .main)
        guard let mainCoordinator = appCoordinator.childCoordinators.first(where: { $0 is MainCoordinator }) as? MainCoordinator else { return false }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            showExhibition(mainCoordinator: mainCoordinator, exhibitionId: exhibitionId)
        }
        return true
    }
    
    @MainActor
    private func showExhibition(mainCoordinator: MainCoordinator, exhibitionId: Int64) {
        mainCoordinator.selectTab(index: 2)
        let exhibitionCoordinator: ExhibitionCoordinator? = mainCoordinator.childCoordinators.first(where: { $0 is ExhibitionCoordinator}) as? ExhibitionCoordinator
        exhibitionCoordinator?.navigate(to: .exhibitionDetail(id: exhibitionId))
    }
}
