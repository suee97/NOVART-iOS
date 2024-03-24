import UIKit

final class ExhibitionCoordinator: BaseStackCoordinator<ExhibitionStep> {
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
        }
    }
    
    @MainActor
    private func showExhibitionDetailScene(exhibitionId: Int64) {
        let root = BaseNavigationController()
        let stackNavigator = StackNavigator(rootViewController: root, presenter: navigator.rootViewController)
        let exhibitionDetailCoordinator = ExhibitionDetailCoordinator(navigator: stackNavigator)
        exhibitionDetailCoordinator.exhibitionId = exhibitionId
        add(coordinators: exhibitionDetailCoordinator)
        
        exhibitionDetailCoordinator.start()
    }
    
    @MainActor
    private func showCommentViewController(exhibitionId: Int64) {
        let viewModel = CommentViewModel(contentId: exhibitionId, contentType: .exhibition)
        let viewController = CommentViewController(viewModel: viewModel)
        let bottomSheetNavigationController = BottomSheetNavigationController()
        bottomSheetNavigationController.pushViewController(viewController, animated: false)
        let height = UIScreen.main.bounds.height - 55
//        var configuration = BottomSheetConfiguration()
//        configuration.customHeight = height
        bottomSheetNavigationController.bottomSheetConfiguration.customHeight = height
        bottomSheetNavigationController.bottomSheetConfiguration.isModalInPresentation = false
        bottomSheetNavigationController.modalPresentationStyle = .pageSheet
        navigator.rootViewController.presentSheet(bottomSheetNavigationController, with: bottomSheetNavigationController.bottomSheetConfiguration)
    }
}
