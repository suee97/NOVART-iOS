//
//  MainTabBarViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/06.
//

import UIKit

final class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    var beforeTabBarIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
        // Do any additional setup after loading the view.
    }
    

    private func setupTabBar() {
        self.delegate = self
        view.backgroundColor = .white
        
        tabBar.clipsToBounds = true
        tabBar.layer.cornerRadius = 12
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
        tabBar.tintColor = UIColor.Common.black
        tabBar.unselectedItemTintColor = UIColor.Common.grey02
        
        tabBar.layer.borderWidth = 0.25
        tabBar.layer.borderColor = UIColor.Common.grey01.cgColor
        // Change to your desired color
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let afterTabBarIndex = tabBarController.selectedIndex
        NotificationCenter.default.post(name: .init(NotificationKeys.scrollToTopKey), object: (before: beforeTabBarIndex, after: afterTabBarIndex))
        beforeTabBarIndex = afterTabBarIndex
    }
}
