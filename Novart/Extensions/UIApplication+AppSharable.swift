//
//  UIApplication+AppSharable.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/02.
//

import UIKit

extension UIApplication {
    
    var sceneDelegate: SceneDelegate? {
        dispatchPrecondition(condition: .onQueue(.main))
        return connectedScenes.first?.delegate as? SceneDelegate
    }
    
    var appCoordinator: AppCoordinator? {
        sceneDelegate?.applicationCoordinator
    }
    
    var windowScene: UIWindowScene? {
        connectedScenes.first as? UIWindowScene
    }
    
    var keyWindowScene: UIWindow? {
        windowScene?.windows.first
    }
    
    var firstKeyWindow: UIWindow? {
        windowScene?.windows.first(where: { $0.isKeyWindow })
    }
    
    var originStatusBarStyle: UIStatusBarStyle {
        windowScene?.statusBarManager?.statusBarStyle ?? .default
    }
    
    var originStatusBarFrame: CGRect {
        windowScene?.statusBarManager?.statusBarFrame ?? .zero
    }
    
    var interfaceOrientation: UIInterfaceOrientation {
        windowScene?.interfaceOrientation ?? .portrait
    }
    
    var isLandscape: Bool {
        interfaceOrientation.isLandscape
    }
    
    var applicationActive: Bool {
        sceneDelegate?.applicationActive ?? false
    }
}
