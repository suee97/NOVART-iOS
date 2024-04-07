//
//  ExhibitionDetailCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/04.
//

import UIKit

final class ExhibitionDetailCoordinator: BaseStackCoordinator<ExhibitionDetailStep>, LoginModalPresentableCoordinator {
    
    var commentViewModel: CommentViewModel?
    
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
        case let .artist(userId):
            closeAndStartMyPageCoordinator(userId: userId)
        case .login:
            presentLoginModal()
        case let .ask(user):
            showAskSheet(user: user)
        default:
            break
        }
    }
    
    @MainActor
    private func showCommentViewController(exhibitionId: Int64) {
        let viewModel = CommentViewModel(contentId: exhibitionId, contentType: .exhibition, coordinator: self)
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
    private func showAskSheet(user: PlainUser) {
        let bottomSheetRoot = BottomSheetNavigationController()
        bottomSheetRoot.bottomSheetConfiguration.customHeight = 248
        let stackNavigator = StackNavigator(rootViewController: bottomSheetRoot, presenter: navigator.rootViewController)
        let coordinator = AskCoordinator(navigator: stackNavigator)
        coordinator.user = user

        add(coordinators: coordinator)
        coordinator.start()
    }
    
}
