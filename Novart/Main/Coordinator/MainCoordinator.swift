//
//  MainCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/25.
//

import UIKit

final class MainCoordinator: BaseWindowCoordinator<MainStep> {
    override func start() {
        
        let homeNavigationController = BaseNavigationController()
        let homeStackNavigator = StackNavigator(rootViewController: homeNavigationController)
        let homeCoordinator = HomeCoordinator(navigator: homeStackNavigator)
        
        let chattingNavigationController = BaseNavigationController()
        let chattingStackNavigator = StackNavigator(rootViewController: chattingNavigationController)
        let chattingCoordinator = ChattingCoordinator(navigator: chattingStackNavigator)
        
        let discoverNavigationController = BaseNavigationController()
        let discoverNavigator = StackNavigator(rootViewController: discoverNavigationController)
        let discoverCoordinator = DiscoverCoordinator(navigator: discoverNavigator)

        let myPageNavigationController = BaseNavigationController()
        let myPageStackNavigator = StackNavigator(rootViewController: myPageNavigationController)
        let myPageCoordinator = MyPageCoordinator(navigator: myPageStackNavigator)
        
        add(coordinators: homeCoordinator, chattingCoordinator, discoverCoordinator, myPageCoordinator)
        
        childCoordinators.forEach { $0.start() }
        
        let mainTabBarViewController = MainTabBarViewController()
        mainTabBarViewController.viewControllers = [
            homeNavigationController,
            chattingNavigationController,
            discoverNavigationController,
            myPageNavigationController
        ]
        
        navigator.start(mainTabBarViewController)
    }
}
