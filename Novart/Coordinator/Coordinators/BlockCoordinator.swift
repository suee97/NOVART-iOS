//
//  BlockCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/02/11.
//

import UIKit

final class BlockCoordinator: BaseStackCoordinator<BlockStep> {
    
    override func start() {
        super.start()
        
        let viewController = BlockViewController()
        navigator.start(viewController)
    }
}
