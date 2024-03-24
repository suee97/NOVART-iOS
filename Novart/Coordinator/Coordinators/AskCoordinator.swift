//
//  AskCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2/12/24.
//

import UIKit

final class AskCoordinator: BaseStackCoordinator<AskStep> {
    
    @LateInit
    var user: PlainUser
    
    override func start() {
        super.start()
        
        let viewController = AskViewController(user: user)
        navigator.start(viewController)
    }
}


