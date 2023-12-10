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
        case let .comment(exhibitionId):
            showCommentViewController(exhibitionId: exhibitionId)
        default:
            break
        }
    }
    
    private func showCommentViewController(exhibitionId: Int64) {
        let viewModel = CommentViewModel(contentId: exhibitionId, contentType: .exhibition)
        let viewController = CommentViewController(viewModel: viewModel)
        
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        navigator.rootViewController.present(viewController, animated: true)
    }
}
