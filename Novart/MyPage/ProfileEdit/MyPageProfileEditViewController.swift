import UIKit
import SnapKit

final class MyPageProfileEditViewController: BaseViewController {

    // MARK: - Constants
    private enum Constants {
        enum Navigation {
            static let navigationBarTitle: String = "프로필 편집"
            static let cancelTitle: String = "취소"
            static let applyTitle: String = "저장"
            static let buttonSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 28, height: 24))
            static let font = UIFont(name: "Apple SD Gothic Neo Regular", size: 16)
        }
    }
    
    // MARK: - Properties
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - UI
    override func setupView() {
        view.backgroundColor = .Common.white
    }
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(frame: Constants.Navigation.buttonSize)
        button.setTitle(Constants.Navigation.cancelTitle, for: .normal)
        button.titleLabel?.font = Constants.Navigation.font
        button.setTitleColor(.Common.grey03, for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.onTapCancel()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton(frame: Constants.Navigation.buttonSize)
        button.setTitle(Constants.Navigation.applyTitle, for: .normal)
        button.titleLabel?.font = Constants.Navigation.font
        button.setTitleColor(.Common.grey02, for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.onTapApply()
        }), for: .touchUpInside)
        return button
    }()
    
    override func setupNavigationBar() {
        navigationItem.title = Constants.Navigation.navigationBarTitle
        let cancelItem = UIBarButtonItem(customView: cancelButton)
        let applyItem = UIBarButtonItem(customView: applyButton)
        self.navigationItem.leftBarButtonItem = cancelItem
        self.navigationItem.rightBarButtonItem = applyItem
    }
    
    private func onTapCancel() {
        print("cancel")
    }
    
    private func onTapApply() {
        print("apply")
    }
}
