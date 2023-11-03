//
//  ProductDetailCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/28.
//

import UIKit

final class ProductDetailCoordinator: BaseStackCoordinator<ProductDetailStep> {
    
    @LateInit
    var productId: Int64
    
    override func start() {
        let viewModel = ProductDetailViewModel(productId: productId, coordinator: self)
        let viewController = ProductDetailViewController(viewModel: viewModel)
        navigator.start(viewController)
    }
    
    override func navigate(to step: ProductDetailStep) {
        switch step {
        case .comment:
            showCommentViewController()
        default:
            break
        }
    }
    
    private func showCommentViewController() {
        let viewModel = CommentViewModel()
        let viewController = CommentViewController(viewModel: viewModel)
        
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        navigator.rootViewController.present(viewController, animated: true)
    }
}
