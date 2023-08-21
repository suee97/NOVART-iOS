//
//  StackNavigator.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/25.
//

import UIKit
import Combine

final class StackNavigator {
    // MARK: - Properties
    
    let rootViewController: UINavigationController
    let presenter: UIViewController?
    
    var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    var onDismissed: (() -> Void)? {
        didSet {
            guard let oldValue else { return }
            self.onDismissed = oldValue
        }
    }
    
    // MARK: - Initialization
    init(
        rootViewController: UINavigationController,
        presenter: UIViewController? = nil) {
            self.rootViewController = rootViewController
            self.presenter = presenter
            
            self.rootViewController.modalPresentationStyle = .fullScreen
        }
}

// MARK: - NavigationActionable
extension StackNavigator: NavigationActionable {
    private func set(root viewController: UIViewController) {
        rootViewController.pushViewController(viewController, animated: false)
    }
    
    private func bind(_ viewController: BaseViewController) {
        Publishers.Merge(viewController.isPopped, viewController.isDismissed)
            .sink { [weak self] _ in
                guard let self else { return }
                guard let onDismissed = self.onDismissed else {
                    fatalError("\(viewController)'s Coordinator is not deallocated")
                }
                onDismissed()
            }
            .store(in: &subscriptions)
    }
    
    private func present(_ viewController: UIViewController, animated: Bool) {
        guard let presenter else { return }
        presenter.present(viewController, animated: animated)
    }
    
    private func target(_ filter: ((UIViewController) throws -> Bool) throws -> UIViewController?, is type: UIViewController.Type) -> UIViewController? {
        try? filter { viewController in
            Swift.type(of: viewController) == type
        }
    }
    
    func start(_ viewController: UIViewController) {
        if self.presenter != nil {
            set(root: viewController)
            present(viewController, animated: true)
        } else if rootViewController.viewControllers.isEmpty {
            set(root: viewController)
        } else {
            push(viewController, animated: true)
        }
        
        if let baseViewController = viewController as? BaseViewController {
            bind(baseViewController)
        }
    }
    
    func push(_ viewController: UIViewController, animated: Bool) {
        rootViewController.pushViewController(viewController, animated: animated)
    }
    
    func pop(animated: Bool) {
        rootViewController.popViewController(animated: animated)
    }
    
    func first(is type: UIViewController.Type) -> UIViewController? {
        let viewControllers = rootViewController.viewControllers
        return self.target(viewControllers.last(where:), is: type)
    }
    
    func last(is type: UIViewController.Type) -> UIViewController? {
        let viewControllers = rootViewController.viewControllers
        return self.target(viewControllers.last(where:), is: type)
    }
    
    func pop(to type: UIViewController.Type, animated: Bool) {
        guard let targetViewController = last(is: type) else { return }
        rootViewController.popToViewController(targetViewController, animated: animated)
    }
    
    func popToRoot(animated: Bool) {
        rootViewController.popToRootViewController(animated: animated)
    }
}

// MARK: - Dismissible
extension StackNavigator: Dismissible {
    func dismiss(animated: Bool) {
        guard presenter != nil else { return }
        rootViewController.dismiss(animated: animated)
    }
}
