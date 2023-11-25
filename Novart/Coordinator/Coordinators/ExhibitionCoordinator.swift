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
}
