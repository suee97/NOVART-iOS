import UIKit
import SnapKit

final class MyPageSettingViewController: BaseViewController {

    // MARK: - Constants
    private enum Constants {
        enum Navigation {
            static let title: String = "설정"
            static let titleTextAttribute = [
                NSAttributedString.Key.font: UIFont(name: "Apple SD Gothic Neo Bold", size: 16)
            ]
            static let backButtonSize = CGSizeMake(24, 24)
        }
    }
    
    
    // MARK: - LifeCycle
    
    
    // MARK: - UI
    private lazy var backButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: Constants.Navigation.backButtonSize))
        button.setBackgroundImage(UIImage(named: "icon_back"), for: .normal)
        button.addAction(UIAction(handler: { _ in
            self.onTapBack()
        }), for: .touchUpInside)
        return button
    }()
    
    override func setupView() {
        view.backgroundColor = .white
    }
    
    override func setupNavigationBar() {
        navigationItem.title = Constants.Navigation.title
        let backItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backItem
    }
    
    private func onTapBack() {
        print("back")
    }
}
