//
//  BaseWindowCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/25.
//

import Foundation

class BaseWindowCoordinator<CurrentStep: Step>: Coordinator {

    typealias CurrentStep = CurrentStep
    
    let navigator: WindowNavigator
    
    weak var parentCoordinator: (any Coordinator)?
    var childCoordinators: [any Coordinator] = []
    
    required init(windowNavigator: WindowNavigator) {
        self.navigator = windowNavigator
    }
    
    func start() {
        
    }
    
    @MainActor
    func navigate(to step: CurrentStep) {

    }
}

