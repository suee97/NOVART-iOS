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
        case let .comment(productId):
            showCommentViewController(productId: productId)
        case let .artist(userId):
            closeAndStartMyPageCoordinator(userId: userId)
        default:
            break
        }
    }
    
    private func showCommentViewController(productId: Int64) {
        let viewModel = CommentViewModel(contentId: productId, contentType: .product)
        let viewController = CommentViewController(viewModel: viewModel)
        
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        navigator.rootViewController.present(viewController, animated: true)
    }
    
    @MainActor
    private func closeAndStartMyPageCoordinator(userId: Int64?) {
        self.close { [weak self] in
            guard let self, let parentCoordinator = self.parentCoordinator , let navigator = parentCoordinator.navigator as? StackNavigator else { return }
            let myPageCoordinator = MyPageCoordinator(navigator: navigator)
            myPageCoordinator.userId = userId
            parentCoordinator.add(coordinators: myPageCoordinator)
            myPageCoordinator.startAsPush()
        }
    }
}
