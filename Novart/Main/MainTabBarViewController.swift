//
//  MainTabBarViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/06.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
        // Do any additional setup after loading the view.
    }
    

    private func setupTabBar() {
        
        view.backgroundColor = .white
        
        tabBar.clipsToBounds = true
        tabBar.layer.cornerRadius = 12
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
        tabBar.tintColor = UIColor.Common.black
        tabBar.unselectedItemTintColor = UIColor.Common.grey02
        
        tabBar.layer.borderWidth = 1.0
        tabBar.layer.borderColor = UIColor.Common.grey01.cgColor
        // Change to your desired color
    }
    
}
