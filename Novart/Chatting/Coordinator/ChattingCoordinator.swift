//
//  ChattingCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/06.
//

import UIKit

final class ChattingCoordinator: BaseStackCoordinator<ChattingStep> {
    override func start() {
        let viewController = ChattingViewController()
        
        let tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_chatting_deselected"),
            selectedImage: UIImage(named: "tab_chatting_selected")
        )
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        viewController.tabBarItem = tabBarItem
        navigator.start(viewController)
    }
}

