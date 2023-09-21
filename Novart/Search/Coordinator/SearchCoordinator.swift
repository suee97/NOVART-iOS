//
//  SearchCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/06.
//

import UIKit

final class SearchCoordinator: BaseStackCoordinator<SearchStep> {
    override func start() {
        let viewModel = SearchViewModel(coordinator: self)
        let viewController = SearchViewController(viewModel: viewModel)
        
        let tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_search_deselected"),
            selectedImage: UIImage(named: "tab_search_selected")
        )
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        viewController.tabBarItem = tabBarItem
        navigator.start(viewController)
    }
}

