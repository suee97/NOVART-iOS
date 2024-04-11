import UIKit
import SnapKit

final class PolicyViewController: BaseViewController {
    
    // MARK: - Constants
    private enum Constants {
        enum Navigation {
            static let buttonSize = CGSize(width: 24, height: 24)
            static let font = UIFont.systemFont(ofSize: 16, weight: .bold)
            static let color = UIColor.Common.black
        }
    }
    
    // MARK: - Properties
    private var policyType: PolicyType
    
    
    // MARK: - Init
    init(policyType: PolicyType) {
        self.policyType = policyType
        super.init()
        print(policyType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    private lazy var backButtonItem: UIBarButtonItem = {
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: Constants.Navigation.buttonSize))
        button.setBackgroundImage(UIImage(named: "icon_back"), for: .normal)
        button.addAction(UIAction(handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
        let item = UIBarButtonItem(customView: button)
        return item
    }()
    
    override func setupNavigationBar() {
        switch policyType {
        case .Usage:
            navigationItem.title = "서비스 이용약관"
        case .Privacy:
            navigationItem.title = "개인정보 처리방침"
        case .Community:
            navigationItem.title = "커뮤니티 이용 가이드라인"
        case .Marketing:
            navigationItem.title = "마케팅(텍스트 미정)"
        }
        
        navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.rightBarButtonItem = nil
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: Constants.Navigation.font,
        ]
    }
    
    override func setupView() {
        view.backgroundColor = .white
    }
}
