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
        
        enum Chapter {
            static let topMargin: CGFloat = 24
            static let bottomMargin: CGFloat = 72
            static let horizontalMargin: CGFloat = 24
            static let verticalSpacing: CGFloat = 24
        }
        
        enum Divider {
            static let width = UIScreen.main.bounds.width - 48
            static let height: CGFloat = 0.5
            static let color = UIColor.Common.grey01
        }
    }
    
    
    // MARK: - Properties
    private var policyType: PolicyType
    private let viewModel = PolicyViewModel()
    
    
    // MARK: - Init
    init(policyType: PolicyType) {
        self.policyType = policyType
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
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
        navigationItem.title = policyType.rawValue
        navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.rightBarButtonItem = nil
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: Constants.Navigation.font,
        ]
    }
    
    override func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints({ m in
            m.left.right.equalToSuperview()
            m.top.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
        contentView.snp.makeConstraints({ m in
            m.top.bottom.equalToSuperview()
            m.left.right.equalTo(view)
        })
        
        let chapterViews = viewModel.getPolicyChapters(category: policyType).map{ PolicyChapterView(chapter: $0) }
        addChapterViews(chapterViews: chapterViews)
    }
    
    private func addChapterViews(chapterViews: [PolicyChapterView]) {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = Constants.Chapter.verticalSpacing
        
        for chapterView in chapterViews {
            stackView.addArrangedSubview(chapterView)
            
            if chapterView == chapterViews.last { break }
            
            let dividerView = UIView()
            dividerView.backgroundColor = Constants.Divider.color
            dividerView.snp.makeConstraints({ m in
                m.width.equalTo(Constants.Divider.width)
                m.height.equalTo(Constants.Divider.height)
            })
            
            stackView.addArrangedSubview(dividerView)
        }

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints({ m in
            m.top.equalToSuperview().inset(Constants.Chapter.topMargin)
            m.bottom.equalToSuperview().inset(Constants.Chapter.bottomMargin)
            m.left.right.equalToSuperview().inset(Constants.Chapter.horizontalMargin)
        })
    }
}
