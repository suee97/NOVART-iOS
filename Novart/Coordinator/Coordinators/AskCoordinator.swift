//
//  AskCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2/12/24.
//

import UIKit

final class AskCoordinator: BaseStackCoordinator<AskStep> {
    
    @LateInit
    var userId: Int64
    
    override func start() {
        super.start()
        
        let viewController = AskViewController()
        navigator.start(viewController)
    }
}


