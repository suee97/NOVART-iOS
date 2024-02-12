//
//  MyPageCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/06.
//

import UIKit

final class MyPageCoordinator: BaseStackCoordinator<MyPageStep> {
    override func start() {
        let viewModel = MyPageViewModel(coordinator: self, userId: nil) // MARK: - TEST
        let viewController = MyPageViewController(viewModel: viewModel)
        
        let tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_my_deselected"),
            selectedImage: UIImage(named: "tab_my_selected")
        )
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        viewController.tabBarItem = tabBarItem
        navigator.start(viewController)
    }
    
    override func navigate(to step: MyPageStep) {
        switch step {
        case .MyPageMain:
            showMain()
        case .MyPageProfileEdit:
            showProfileEdit()
        case .MyPageSetting:
            showSetting()
        case .MyPageNotification:
            showNotification()
        case .LoginModal:
            showLoginModal()
        case .Close:
            close()
            
        case let .product(id):
            presentProductDetailVC(productId: id)
        case let .artist(id):
            showArtistProfile(userId: id)
        case let .exhibitionDetail(id):
            showExhibitionDetailScene(exhibitionId: id)
        }
    }
    
    private func showMain() {
        navigator.pop(animated: true)
    }
    
    private func showProfileEdit() {
        guard let user = Authentication.shared.user else { return }
        let viewModel = MyPageProfileEditViewModel(coordinator: self, user: user)
        let viewController = MyPageProfileEditViewController(viewModel: viewModel)
        navigator.push(viewController, animated: true)
    }
    
    private func showSetting() {
        let user: PlainUser? = Authentication.shared.user
        let viewModel = MyPageSettingViewModel(coordinator: self, user: user)
        let viewController = MyPageSettingViewController(viewModel: viewModel)
        navigator.push(viewController, animated: true)
    }
    
    private func showNotification() {
        let viewModel = MyPageNotificationViewModel(coordinator: self)
        let viewController = MyPageNotificationViewController(viewModel: viewModel)
        navigator.push(viewController, animated: true)
    }
    
    private func showLoginModal() {
        let viewController = LoginModalViewController()
//        if let sheet = viewController.sheetPresentationController {
//            sheet.detents = [.large()]
//            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
//            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
//        }
        navigator.rootViewController.present(viewController, animated: true)
    }
    
    private func close() {
        navigator.pop(animated: true)
    }
    
    private func presentProductDetailVC(productId: Int64) {
        let root = BaseNavigationController()
        let productDetailStackNavigator = StackNavigator(rootViewController: root, presenter: navigator.rootViewController)
        let productDetailCoordinator = ProductDetailCoordinator(navigator: productDetailStackNavigator)
        productDetailCoordinator.productId = productId
        add(coordinators: productDetailCoordinator)
        
        productDetailCoordinator.start()
    }
    
    private func showArtistProfile(userId: Int64) {
        let viewModel = MyPageViewModel(coordinator: self, userId: userId)
        let viewController = MyPageViewController(viewModel: viewModel)
        navigator.push(viewController, animated: true)
    }
    
    private func showExhibitionDetailScene(exhibitionId: Int64) {
        let root = BaseNavigationController()
        let stackNavigator = StackNavigator(rootViewController: root, presenter: navigator.rootViewController)
        let exhibitionDetailCoordinator = ExhibitionDetailCoordinator(navigator: stackNavigator)
        exhibitionDetailCoordinator.exhibitionId = exhibitionId
        add(coordinators: exhibitionDetailCoordinator)
        
        exhibitionDetailCoordinator.start()
    }
}

