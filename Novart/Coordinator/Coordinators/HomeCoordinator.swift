//
//  HomeCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/06.
//

import UIKit

final class HomeCoordinator: BaseStackCoordinator<HomeStep> {
    override func start() {
        super.start()
        let viewModel = HomeViewModel(coordinator: self)
        let viewController = HomeViewController(viewModel: viewModel)
        
        let tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_home_deselected"),
            selectedImage: UIImage(named: "tab_home_selected")
        )
        
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        viewController.tabBarItem = tabBarItem
        navigator.start(viewController)
    }
    
    override func navigate(to step: HomeStep) {
        switch step {
        case let .productDetail(id):
            presentProductDetailVC(productId: id)
        case .block:
            presentBlockSheet()
        default:
            break
        }
    }
    
    @MainActor
    func presentSetNicknameModal() {
        if let vc = UIApplication.shared.currentViewController {
            let viewModel = SetNicknameViewModel(coordinator: self)
            let setNicknameVC = SetNicknameViewController(viewModel: viewModel)
            vc.present(setNicknameVC, animated: true)
        }
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
    
    @MainActor
    private func presentBlockSheet() {
        let bottomSheetRoot = BottomSheetNavigationController()
        bottomSheetRoot.bottomSheetConfiguration.customHeight = 400
        let stackNavigator = StackNavigator(rootViewController: bottomSheetRoot, presenter: navigator.rootViewController)
        let coordinator = BlockCoordinator(navigator: stackNavigator)
        
        add(coordinators: coordinator)
        coordinator.start()
    }
}
