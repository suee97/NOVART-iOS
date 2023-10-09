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
        case .ProfileEdit:
            showProfileEdit()
        }
    }
    
    private func showProfileEdit() {
        let viewController = MyPageProfileEditViewController()
        navigator.push(viewController, animated: true)
    }
}

