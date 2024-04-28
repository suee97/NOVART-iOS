//
//  ProductDetailCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/28.
//

import UIKit

final class ProductDetailCoordinator: BaseStackCoordinator<ProductDetailStep>, LoginModalPresentableCoordinator {
    
    var commentViewModel: CommentViewModel?
    
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
        case let .edit(product):
            showProductEditScene(product: product)
        case .login:
            presentLoginModal()
        case let .ask(user):
            showAskSheet(user: user)
        case .report:
            showReportSheet(productId: productId)
        case let .search(query):
            closeAndShowSearch(query: query)
        case let .product(productId):
            closeAndShowProduct(id: productId)
        case let .exhibition(id):
            closeAndShowExhibition(id: id)
            
        default:
            break
        }
    }
    
    private func showCommentViewController(productId: Int64) {
        let viewModel = CommentViewModel(contentId: productId, contentType: .product, coordinator: self)
        commentViewModel = viewModel
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
    
    @MainActor
    private func closeAndShowSearch(query: String) {
        self.close { [weak self] in
            guard let self, let parentCoordinator = self.parentCoordinator , let navigator = parentCoordinator.navigator as? StackNavigator else { return }
            let searchCoordinator = SearchCoordinator(navigator: navigator)
            parentCoordinator.add(coordinators: searchCoordinator)
            searchCoordinator.startAsPush(query: query)
        }
    }
    
    @MainActor
    private func showProductEditScene(product: ProductUploadModel) {
        let productUploadCoordinator = ProductUploadCoordinator(navigator: navigator)
        productUploadCoordinator.productModel = product
        add(coordinators: productUploadCoordinator)
        productUploadCoordinator.startAsPush()
    }
    
    @MainActor
    private func showAskSheet(user: PlainUser) {
        let bottomSheetRoot = BottomSheetNavigationController()
        bottomSheetRoot.bottomSheetConfiguration.customHeight = 248
        let stackNavigator = StackNavigator(rootViewController: bottomSheetRoot, presenter: navigator.rootViewController)
        let coordinator = AskCoordinator(navigator: stackNavigator)
        coordinator.user = user

        add(coordinators: coordinator)
        coordinator.start()
    }
    
    @MainActor
    private func showReportSheet(productId: Int64) {
        let bottomSheetRoot = BottomSheetNavigationController()
        bottomSheetRoot.bottomSheetConfiguration.customHeight = 390
        let stackNavigator = StackNavigator(rootViewController: bottomSheetRoot, presenter: navigator.rootViewController)
        let coordinator = ReportCoordinator(navigator: stackNavigator)
        coordinator.id = productId
        coordinator.reportDomain = .product
        
        add(coordinators: coordinator)
        coordinator.start()
    }
    
    @MainActor
    private func closeAndShowProduct(id: Int64) {
        self.close { [weak self] in
            guard let self, let parentCoordinator = self.parentCoordinator , let navigator = parentCoordinator.navigator as? StackNavigator else { return }
            let root = BaseNavigationController()
            let productDetailStackNavigator = StackNavigator(rootViewController: root, presenter: navigator.rootViewController)
            let productDetailCoordinator = ProductDetailCoordinator(navigator: productDetailStackNavigator)
            productDetailCoordinator.productId = id
            parentCoordinator.add(coordinators: productDetailCoordinator)
            productDetailCoordinator.start()
        
        }
    }
    
    @MainActor
    private func closeAndShowExhibition(id: Int64) {
        
        self.close { [weak self] in
            guard let self, let parentCoordinator = self.parentCoordinator , let navigator = parentCoordinator.navigator as? StackNavigator else { return }
            let root = BaseNavigationController()
            let stackNavigator = StackNavigator(rootViewController: root, presenter: navigator.rootViewController)
            let exhibitionDetailCoordinator = ExhibitionDetailCoordinator(navigator: stackNavigator)
            exhibitionDetailCoordinator.exhibitionId = id
            parentCoordinator.add(coordinators: exhibitionDetailCoordinator)
            exhibitionDetailCoordinator.start()

        }
    }
}
