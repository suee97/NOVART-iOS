//
//  BaseStackCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/25.
//

import Foundation

class BaseStackCoordinator<CurrentStep: Step>: Coordinator {

    typealias CurrentStep = CurrentStep
    
    let navigator: StackNavigator
    
    weak var parentCoordinator: (any Coordinator)?
    var childCoordinators: [any Coordinator] = []
    
    required init(navigator: StackNavigator) {
        self.navigator = navigator
    }
    
    @MainActor
    func start() {
        navigator.onDismissed = { [weak self] in
            self?.end()
        }
    }
    
    @MainActor
    func navigate(to step: CurrentStep) {

    }
}

