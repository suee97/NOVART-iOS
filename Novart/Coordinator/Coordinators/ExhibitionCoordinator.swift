import UIKit

final class ExhibitionCoordinator: BaseStackCoordinator<ExhibitionStep>, LoginModalPresentableCoordinator {
    
    var commentViewModel: CommentViewModel?

    override func start() {
        super.start()
        let viewModel = ExhibitionViewModel(coordinator: self)
        let viewController = ExhibitionViewController(viewModel: viewModel)
        
        let tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_exhibition_deselected"),
            selectedImage: UIImage(named: "tab_exhibition_selected")
        )
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        viewController.tabBarItem = tabBarItem
        navigator.start(viewController)
    }
    
    override func navigate(to step: ExhibitionStep) {
        switch step {
        case let .exhibitionDetail(id):
            showExhibitionDetailScene(exhibitionId: id)
        case let .comment(id):
            showCommentViewController(exhibitionId: id)
        case .login:
            presentLoginModal()
        case let .artist(userId):
            showUserProfile(userId: userId)
        case let .exhibitionGuide(id, backgroundColor):
            showExhibitionGuide(id: id, backgroundColor: backgroundColor)
        }
    }
    
    @MainActor
    private func showExhibitionDetailScene(exhibitionId: Int64) {
        if let presentedViewController = navigator.rootViewController.presentedViewController {
            navigator.rootViewController.dismiss(animated: true)
        }
        
        let root = BaseNavigationController()
        let stackNavigator = StackNavigator(rootViewController: root, presenter: navigator.rootViewController)
        let exhibitionDetailCoordinator = ExhibitionDetailCoordinator(navigator: stackNavigator)
        exhibitionDetailCoordinator.exhibitionId = exhibitionId
        add(coordinators: exhibitionDetailCoordinator)
        
        exhibitionDetailCoordinator.start()
    }
    
    @MainActor
    private func showCommentViewController(exhibitionId: Int64) {
        let viewModel = CommentViewModel(contentId: exhibitionId, contentType: .exhibition, coordinator: self)
        commentViewModel = viewModel
        let viewController = CommentViewController(viewModel: viewModel)
        let bottomSheetNavigationController = BottomSheetNavigationController()
        bottomSheetNavigationController.pushViewController(viewController, animated: false)
        let height = UIScreen.main.bounds.height - 132
        bottomSheetNavigationController.bottomSheetConfiguration.customHeight = height
        bottomSheetNavigationController.modalPresentationStyle = .pageSheet
        navigator.rootViewController.presentSheet(bottomSheetNavigationController, with: bottomSheetNavigationController.bottomSheetConfiguration)
    }
    
    @MainActor
    private func showUserProfile(userId: Int64) {
        let myPageCoordinator = MyPageCoordinator(navigator: navigator)
        myPageCoordinator.userId = userId
        add(coordinators: myPageCoordinator)
        myPageCoordinator.startAsPush()
    }
    
    @MainActor
    private func showExhibitionGuide(id: Int64, backgroundColor: UIColor) {
        let downloadInteractor = ExhibitionInteractor()
        let viewModel = ExhibitionGuideViewModel(exhibitionId: id, backgroundColor: backgroundColor, coordinator: self, downloadInteractor: downloadInteractor)
        let viewController = ExhibitionGuideViewController(viewModel: viewModel)
        let bottomSheetNavigationController = BottomSheetNavigationController()
        bottomSheetNavigationController.pushViewController(viewController, animated: false)
        let height = UIScreen.main.bounds.height
        bottomSheetNavigationController.bottomSheetConfiguration.customHeight = height
        bottomSheetNavigationController.modalPresentationStyle = .pageSheet
        navigator.rootViewController.presentSheet(bottomSheetNavigationController, with: bottomSheetNavigationController.bottomSheetConfiguration)
    }
}
