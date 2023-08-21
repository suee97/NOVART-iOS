//
//  BaseNavigationController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/25.
//


import UIKit

protocol CoordinatorNavigationControllerDelegate: AnyObject {
    func transitionBackFinished()
}

class BaseNavigationController: UINavigationController {
    
    weak var swipeBackDelegate: CoordinatorNavigationControllerDelegate?
    
    private(set) var transition: UIViewControllerAnimatedTransitioning?
    private var shouldEnableSwipeBack = false
    fileprivate var duringPushAnimation = false
    
    // MARK: -
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        topViewController?.preferredStatusBarStyle ?? .default
    }
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        enableSwipeBack()
        setupNavigationBarAppearance()
    }
    
    private func setupNavigationBarAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.shadowColor = .clear
    
        navigationBar.compactAppearance = navigationBarAppearance
        navigationBar.standardAppearance = navigationBarAppearance
        navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    // MARK: - Public methods
    
    func enableSwipeBack() {
        self.shouldEnableSwipeBack = true
        self.interactivePopGestureRecognizer?.isEnabled = true
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    func disableSwipeBack() {
        self.interactivePopGestureRecognizer?.isEnabled = false
        self.interactivePopGestureRecognizer?.delegate = nil
    }
    
    // MARK: - Overrides
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.isEmpty == false {
            viewController.navigationItem.setLeftBarButton(backButtonItem(), animated: true)
        }
        self.duringPushAnimation = true
        super.pushViewController(viewController, animated: animated)
    }
    
}

// MARK: - Extensions
// MARK: - UINavigationControllerDelegate

extension BaseNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transition
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let coordinator = navigationController.topViewController?.transitionCoordinator {
            coordinator.notifyWhenInteractionChanges { context in
                if !context.isCancelled {
                    self.swipeBackDelegate?.transitionBackFinished()
                }
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let swipeNavigationController = navigationController as? BaseNavigationController else { return }
        swipeNavigationController.duringPushAnimation = false
    }
    
}

// MARK: - UIGestureRecognizerDelegate

extension BaseNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == self.interactivePopGestureRecognizer else {
            return true
        }
        
        return self.viewControllers.count > 1 && self.duringPushAnimation == false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
