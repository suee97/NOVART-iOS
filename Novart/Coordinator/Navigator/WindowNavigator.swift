//
//  WindowNavigator.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/25.
//

import UIKit

final class WindowNavigator {
    
    //MARK: - Properties
    let window: UIWindow
    var level: UIWindow.Level {
        get { window.windowLevel }
        set { window.windowLevel = newValue }
    }
    
    // MARK: - nitialization
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - Methods
    func makeKey() {
        window.makeKey()
    }
    
    func makeKeyAndVisible() {
        window.makeKeyAndVisible()
    }
    
    func resignKey() {
        window.resignKey()
    }
}

extension WindowNavigator: NavigationActionable {
    
    var rootViewController: UIViewController? {
        window.rootViewController
    }
    
    var navigationController: BaseNavigationController? {
        window.rootViewController as? BaseNavigationController
    }
    
    func start(_ viewController: UIViewController) {
        DispatchQueue.main.async {
            self.window.rootViewController = viewController
        }
    }
    
    func push(_ viewController: UIViewController, animated: Bool) {
        guard let navigationController else { return }
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func pop(animated: Bool) {
        guard let navigationController else { return }
        navigationController.popViewController(animated: animated)
    }
    
    func first(is type: UIViewController.Type) -> UIViewController? {
        guard let navigationController else { return nil }
        let viewControllers = navigationController.viewControllers
        
        return target(viewControllers.first(where:), is: type)
    }
    
    func last(is type: UIViewController.Type) -> UIViewController? {
        guard let navigationController else { return nil }
        let viewControllers = navigationController.viewControllers
        
        return target(viewControllers.last(where:), is: type)
    }
    
    private func target(_ filter: ((UIViewController) throws -> Bool) throws -> UIViewController?, is type: UIViewController.Type) -> UIViewController? {
        try? filter { viewController in
            Swift.type(of: viewController) == type
        }
    }
    
    func pop(to type: UIViewController.Type, animated: Bool) {
        guard let navigationController, let targetViewController = last(is: type) else { return }
        
        navigationController.popToViewController(targetViewController, animated: animated)
    }
    
    func popToRoot(animated: Bool) {
        guard let navigationController else { return }
        navigationController.popToRootViewController(animated: animated)
    }
    
}

