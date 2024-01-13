//
//  MyPageCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/06.
//

import UIKit

final class MyPageCoordinator: BaseStackCoordinator<MyPageStep> {
    override func start() {
        let viewModel = MyPageViewModel(coordinator: self)
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
        case .productUpload:
            showProductUploadScene()
        }
    }
    
    private func showMain() {
        navigator.pop(animated: true)
    }
    
    private func showProfileEdit() {
        let viewModel = MyPageProfileEditViewModel(coordinator: self)
        let viewController = MyPageProfileEditViewController(viewModel: viewModel)
        navigator.push(viewController, animated: true)
    }
    
    private func showSetting() {
        let viewModel = MyPageSettingViewModel(coordinator: self)
        let viewController = MyPageSettingViewController(viewModel: viewModel)
        navigator.push(viewController, animated: true)
    }
    
    private func showNotification() {
        let viewModel = MyPageNotificationViewModel(coordinator: self)
        let viewController = MyPageNotificationViewController(viewModel: viewModel)
        navigator.push(viewController, animated: true)
    }
    
    private func showProductUploadScene() {
        let root = BaseNavigationController()
        let productUploadStackNavigator = StackNavigator(rootViewController: root, presenter: navigator.rootViewController)
        let productUploadCoordinator = ProductUploadCoordinator(navigator: productUploadStackNavigator)
        add(coordinators: productUploadCoordinator)
        productUploadCoordinator.start()
    }
}

