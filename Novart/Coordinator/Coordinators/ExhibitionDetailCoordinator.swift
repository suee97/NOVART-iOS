//
//  ExhibitionDetailCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/04.
//

import UIKit

final class ExhibitionDetailCoordinator: BaseStackCoordinator<ExhibitionDetailStep> {
    
    @LateInit
    var exhibitionId: Int64
    
    override func start() {
        let viewModel = ExhibitionDetailViewModel(coordinator: self, exhibitionId: exhibitionId)
        let viewController = ExhibitionDetailViewController(viewModel: viewModel)
        navigator.start(viewController)
    }
    
    override func navigate(to step: ExhibitionDetailStep) {
        switch step {
        case .comment:
            break
        default:
            break
        }
    }
}
