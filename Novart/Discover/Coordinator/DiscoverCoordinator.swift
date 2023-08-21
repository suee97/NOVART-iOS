//
//  DiscoverCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/06.
//

import UIKit

final class DiscoverCoordinator: BaseStackCoordinator<DiscoverStep> {
    override func start() {
        super.start()
        let viewModel = DiscoverViewModel(coordinator: self)
        let viewController = DiscoverViewController(viewModel: viewModel)
        
        let tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_discover_deselected"),
            selectedImage: UIImage(named: "tab_discover_selected")
        )
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        viewController.tabBarItem = tabBarItem
        navigator.start(viewController)
    }
}
