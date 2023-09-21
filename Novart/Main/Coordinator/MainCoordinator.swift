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
        
        let searchNavigationController = BaseNavigationController()
        let searchStackNavigator = StackNavigator(rootViewController: searchNavigationController)
        let searchCoordinator = SearchCoordinator(navigator: searchStackNavigator)
        
        let discoverNavigationController = BaseNavigationController()
        let discoverNavigator = StackNavigator(rootViewController: discoverNavigationController)
        let discoverCoordinator = DiscoverCoordinator(navigator: discoverNavigator)

        let myPageNavigationController = BaseNavigationController()
        let myPageStackNavigator = StackNavigator(rootViewController: myPageNavigationController)
        let myPageCoordinator = MyPageCoordinator(navigator: myPageStackNavigator)
        
        add(coordinators: homeCoordinator, searchCoordinator, discoverCoordinator, myPageCoordinator)
        
        childCoordinators.forEach { $0.start() }
        
        let mainTabBarViewController = MainTabBarViewController()
        mainTabBarViewController.viewControllers = [
            homeNavigationController,
            searchNavigationController,
            discoverNavigationController,
            myPageNavigationController
        ]
        
        navigator.start(mainTabBarViewController)
    }
}
