//
//  BlockCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/02/11.
//

import UIKit

final class BlockCoordinator: BaseStackCoordinator<BlockStep> {
    
    @LateInit
    var userId: Int64
    
    override func start() {
        super.start()
        
        let viewController = BlockViewController()
        navigator.start(viewController)
    }
}
