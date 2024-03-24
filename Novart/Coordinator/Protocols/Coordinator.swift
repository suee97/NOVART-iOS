//
//  Coordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/25.
//

import Foundation

protocol Coordinator: AnyObject {
    associatedtype CurrentStep: Step
    associatedtype Navigator: NavigationActionable
    
    var navigator: Navigator { get }
    
    var parentCoordinator: (any Coordinator)? { get set } /// weak property
    var childCoordinators: [any Coordinator] { get set }
    
    func start()
    func navigate(to step: CurrentStep)
    func back(to step: Step)
    func add(coordinators: (any Coordinator)...)
    func remove(coordinators: (any Coordinator)...)
    func end()
}

extension Coordinator {
    
    func back(to step: Step) {
        guard let target = step.target else { return }
        navigator.pop(to: target, animated: step.animated)
    }
    
    func add(coordinators: (any Coordinator)...) {
        coordinators.forEach { coordinator in
            childCoordinators.append(coordinator)
            coordinator.parentCoordinator = self
        }
    }
    
    func remove(coordinators: (any Coordinator)...) {
        childCoordinators = childCoordinators.filter { childCoordinator in
            !coordinators.contains { coordinator in
                childCoordinator === coordinator
            }
        }
    }
    
    func end() {
        for coordinator in self.childCoordinators {
            coordinator.end()
        }
        parentCoordinator?.remove(coordinators: self)
    }
    
    func closeAsPop() {
        navigator.pop(animated: true)
        end()
    }
    
    func closeToRoot() {
        navigator.popToRoot(animated: true)
        end()
    }
    
    func close(completion: (() -> Void)? = nil) {
        if let dismissible = navigator as? Dismissible {
            dismissible.dismiss(animated: true)
            completion?()
            end()
        }
    }
    
    func closeAll() {
        if let navigator = parentCoordinator?.navigator as? StackNavigator, let presenter = navigator.presenter {
            presenter.dismiss(animated: true)
        } else {
            close()
        }
    }
}
