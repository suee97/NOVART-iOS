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
        
        let exhibitionNavigationController = BaseNavigationController()
        let exhibitionNavigator = StackNavigator(rootViewController: exhibitionNavigationController)
        let exhibitionCoordinator = ExhibitionCoordinator(navigator: exhibitionNavigator)

        let myPageNavigationController = BaseNavigationController()
        let myPageStackNavigator = StackNavigator(rootViewController: myPageNavigationController)
        let myPageCoordinator = MyPageCoordinator(navigator: myPageStackNavigator)
        
        add(coordinators: homeCoordinator, searchCoordinator, exhibitionCoordinator, myPageCoordinator)
        
        childCoordinators.forEach { $0.start() }
        
        let mainTabBarViewController = MainTabBarViewController()
        mainTabBarViewController.viewControllers = [
            homeNavigationController,
            searchNavigationController,
            exhibitionNavigationController,
            myPageNavigationController
        ]
        
        navigator.start(mainTabBarViewController)
    }
}
