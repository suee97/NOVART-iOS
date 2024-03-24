//
//  BlockCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/02/11.
//

import UIKit

final class BlockCoordinator: BaseStackCoordinator<BlockStep> {
    
    @LateInit
    var user: PlainUser
    
    override func start() {
        super.start()
        
        let viewModel = BlockViewModel(user: user, coordinator: self)
        let viewController = BlockViewController(viewModel: viewModel)
        navigator.start(viewController)
    }
    
    @MainActor
    func closeWithProfilepPop() {
        guard let myPageCoordinator = parentCoordinator as? MyPageCoordinator else { return }
        close {
            myPageCoordinator.close()
        }
    }
}
