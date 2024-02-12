//
//  SearchCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/06.
//

import UIKit

final class SearchCoordinator: BaseStackCoordinator<SearchStep> {
    override func start() {
        let viewModel = SearchViewModel(data: nil, coordinator: self)
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
    
    override func navigate(to step: SearchStep) {
        switch step {
        case let .search(data):
            showSearchResultScene(data: data)
        case let .product(id):
            presentProductDetailVC(productId: id)
        default: break
        }
    }
    
    @MainActor
    private func showSearchResultScene(data: SearchResultModel) {
        let viewModel = SearchViewModel(data: data, coordinator: self)
        let searchViewController = SearchViewController(viewModel: viewModel)
        navigator.push(searchViewController, animated: true)
    }
    
    @MainActor
    private func presentProductDetailVC(productId: Int64) {
        let root = BaseNavigationController()
        let productDetailStackNavigator = StackNavigator(rootViewController: root, presenter: navigator.rootViewController)
        let productDetailCoordinator = ProductDetailCoordinator(navigator: productDetailStackNavigator)
        productDetailCoordinator.productId = productId
        add(coordinators: productDetailCoordinator)
        
        productDetailCoordinator.start()
    }
}

