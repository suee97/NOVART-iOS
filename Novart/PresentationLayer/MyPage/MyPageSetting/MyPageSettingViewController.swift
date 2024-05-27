import UIKit
import SnapKit
import Combine

final class MyPageSettingViewController: BaseViewController {

    // MARK: - Constants
    private enum Constants {
        static let screenWidth = UIScreen.main.bounds.size.width
        static let defaultHorizontalMargin: CGFloat = 24
        static let defaultVerticalMargin: CGFloat = 24
        static let cellHeight: CGFloat = 40
        static let primaryFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
        static let primaryColor = UIColor.Common.black
        
        enum Navigation {
            static let title: String = "설정"
            static let buttonSize = CGSize(width: 24, height: 24)
        }
        
        enum Divider {
            static let thickness: CGFloat = 0.5
            static let color = UIColor.Common.grey01
        }
        
        enum Notification {
            static let sectionTitle: String = "알림 설정"
            static let sectionTitleTopMargin: CGFloat = 16
            
            static let activityTitle: String = "활동 알림"
            static let activityDesc: String = "관심, 댓글, 팔로우 등 알림"
            static let activityTopMargin: CGFloat = 16
            
            static let registerTitle: String = "등록 알림"
            static let registerDesc: String = "팔로우한 작가가 작품 등록 시 알림"
            
            static let serviceTitle: String = "서비스 알림"
            static let serviceDesc: String = "공지사항이나 이벤트, 업데이트 등 알림"
            
            static let inquireTitle: String = "문의 차단"
            static let inquireDesc: String = "다른 사용자의 문의를 차단"
        }
        
        enum UsageInfo {
            static let sectionTitle: String = "이용 정보"
            static let sectionNonLoginTopMargin: CGFloat = 24
            
            static let usagePolicyTitle: String = "이용약관"
            static let usagePolicyTopMargin: CGFloat = 8
            
            static let privacyPolicyTitle: String = "개인정보처리방침"
            static let privacyPolicyTopMargin: CGFloat = 8
            
            static let communityPolicyTitle: String = "커뮤니티 이용 가이드라인"
            static let communityPolicyTopMargin: CGFloat = 8
            
            static let bottomDividerOffset: CGFloat = 16
        }
        
        enum Etc {
            static let sectionTitle: String = "기타"
            
            static let noticeTitle: String = "공지사항"
            static let noticeTopMargin: CGFloat = 8
            
            static let updateTitle: String = "최신버전 업데이트"
            static let updateTopMargin: CGFloat = 16
        }
        
        enum Account {
            static let logoutTitle: String = "로그아웃"
            static let logoutTopMargin: CGFloat = 15
            
            static let deleteTitle: String = "탈퇴하기"
            static let deleteTopMargin: CGFloat = 6
            static let deletBottomMargin: CGFloat = 49
        }
        
        enum LoginButton {
            static let text = "로그인 하기"
            static let height = (Constants.screenWidth - 48) * 54 / 342
            static let topMargin: CGFloat = 16
            static let font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
    }
    
    
    // MARK: - Properties
    private let viewModel: MyPageSettingViewModel
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Bindings
    override func setupBindings() {
        Publishers
            .CombineLatest4(self.viewModel.$activityState, self.viewModel.$registerState, self.viewModel.$serviceState, self.viewModel.$inquireState)
            .sink { activity, register, service, inquire in
                DispatchQueue.main.async {
                    self.activityToggleView.isOn = activity
                    self.registerToggleView.isOn = register
                    self.serviceToggleView.isOn = service
                    self.inquireToggleView.isOn = inquire
                }
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        viewModel.fetchSetting()
    }
    
    init(viewModel: MyPageSettingViewModel) {
        self.viewModel = viewModel
        super.init()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    private let scrollView: MyPageSettingScrollView = {
        let scrollView = MyPageSettingScrollView()
        scrollView.delaysContentTouches = false
        scrollView.canCancelContentTouches = true
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private lazy var backButtonItem: UIBarButtonItem = {
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: Constants.Navigation.buttonSize))
        button.setBackgroundImage(UIImage(named: "icon_back"), for: .normal)
        button.addAction(UIAction(handler: { _ in
            self.viewModel.showMain()
        }), for: .touchUpInside)
        let item = UIBarButtonItem(customView: button)
        return item
    }()
    
    private lazy var cancelButtonItem: UIBarButtonItem = {
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: Constants.Navigation.buttonSize))
        button.setBackgroundImage(UIImage(named: "icon_cancel"), for: .normal)
        button.addAction(UIAction(handler: { _ in
            self.viewModel.showMain()
        }), for: .touchUpInside)
        let item = UIBarButtonItem(customView: button)
        return item
    }()
    
    private let notificationSectionLabel = SectionTitleLabel(title: Constants.Notification.sectionTitle)
    
    private let usageSectionLabel = SectionTitleLabel(title: Constants.UsageInfo.sectionTitle)
    
    private let etcSectionLabel = SectionTitleLabel(title: Constants.Etc.sectionTitle)
    
    private lazy var activityToggleView = ToggleSwitchView(title: Constants.Notification.activityTitle, desc: Constants.Notification.activityDesc, isOn: false, onSwitch: {
        self.viewModel.activityState = $0
        self.viewModel.putSetting(setting: MyPageSettingRequestModel(category: .activicy, setting: $0))
    })
    
    private lazy var registerToggleView = ToggleSwitchView(title: Constants.Notification.registerTitle, desc: Constants.Notification.registerDesc, isOn: false, onSwitch: {
        self.viewModel.registerState = $0
        self.viewModel.putSetting(setting: MyPageSettingRequestModel(category: .register, setting: $0))
    })
    
    private lazy var serviceToggleView = ToggleSwitchView(title: Constants.Notification.serviceTitle, desc: Constants.Notification.serviceDesc, isOn: false, onSwitch: {
        self.viewModel.serviceState = $0
        self.viewModel.putSetting(setting: MyPageSettingRequestModel(category: .service, setting: $0))
    })
    
    private lazy var inquireToggleView = ToggleSwitchView(title: Constants.Notification.inquireTitle, desc: Constants.Notification.inquireDesc, isOn: false, onSwitch: {
        self.viewModel.inquireState = $0
        self.viewModel.putSetting(setting: MyPageSettingRequestModel(category: .inquire, setting: $0))
    })
    
    private lazy var usagePolicyButton = TextNavigationButton(title: Constants.UsageInfo.usagePolicyTitle, onTap: {
        self.viewModel.showPolicy(policyType: .Usage)
    })
    
    private lazy var privacyPolicyButton = TextNavigationButton(title: Constants.UsageInfo.privacyPolicyTitle, onTap: {
        self.viewModel.showPolicy(policyType: .Privacy)
    })
    
    private lazy var communityPolicyButton = TextNavigationButton(title: Constants.UsageInfo.communityPolicyTitle, onTap: {
        self.viewModel.showPolicy(policyType: .Community)
    })
    
    private let noticePolicyButton = TextNavigationButton(title: Constants.Etc.noticeTitle, onTap: {
        print("noticePolicyRowView !!")
    })
    
    // 실제 데이터 받을 때 수정 필요
    private let updateInfoView: UIView = {
        let view = ToggleSwitchView(title: Constants.Etc.updateTitle, desc: "최신버전: 23.23.0", isOn: false, onSwitch: { _ in })
        view.toggle.removeFromSuperview()
        
        let infoLabel = UILabel()
        infoLabel.text = "23.10.2(23102)"
        infoLabel.font = Constants.primaryFont
        
        view.addSubview(infoLabel)
        infoLabel.snp.makeConstraints({ m in
            m.right.centerY.equalToSuperview()
        })
        
        return view
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Constants.primaryColor, for: .normal)
        button.setTitle(Constants.Account.logoutTitle, for: .normal)
        button.titleLabel?.font = Constants.primaryFont
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.showLogoutAlert()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Constants.primaryColor, for: .normal)
        button.setTitle(Constants.Account.deleteTitle, for: .normal)
        button.titleLabel?.font = Constants.primaryFont
        button.addAction(UIAction(handler: { [weak self] _ in
            // TODO: 서버 개발 대기 중
//            self?.viewModel.showDeleteAlert()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var loginButton: PlainButton = {
        let button = PlainButton()
        button.setTitle(Constants.LoginButton.text, for: .normal)
        button.titleLabel?.font = Constants.LoginButton.font
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.viewModel.showLoginModal()
        }), for: .touchUpInside)
        return button
    }()
    
    override func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        if viewModel.user != nil {
            contentView.addSubview(notificationSectionLabel)
            contentView.addSubview(activityToggleView)
            contentView.addSubview(registerToggleView)
            contentView.addSubview(serviceToggleView)
            contentView.addSubview(inquireToggleView)
            contentView.addSubview(logoutButton)
            contentView.addSubview(deleteButton)
        } else {
            contentView.addSubview(loginButton)
        }
        
        contentView.addSubview(usageSectionLabel)
        contentView.addSubview(usagePolicyButton)
        contentView.addSubview(privacyPolicyButton)
        contentView.addSubview(communityPolicyButton)
        contentView.addSubview(etcSectionLabel)
        contentView.addSubview(noticePolicyButton)
        contentView.addSubview(updateInfoView)
        
        scrollView.snp.makeConstraints({ m in
            m.edges.equalTo(view.safeAreaLayoutGuide)
        })
        
        contentView.snp.makeConstraints({ m in
            m.top.bottom.width.equalToSuperview()
        })
        
        if viewModel.user != nil {
            notificationSectionLabel.snp.makeConstraints({ m in
                m.left.equalToSuperview().inset(Constants.defaultHorizontalMargin)
                m.top.equalToSuperview().inset(Constants.Notification.sectionTitleTopMargin)
            })
            
            activityToggleView.snp.makeConstraints({ m in
                m.left.right.equalToSuperview().inset(Constants.defaultHorizontalMargin)
                m.top.equalTo(notificationSectionLabel.snp.bottom).offset(Constants.Notification.activityTopMargin)
                m.height.equalTo(Constants.cellHeight)
            })
            
            registerToggleView.snp.makeConstraints({ m in
                m.left.right.equalToSuperview().inset(Constants.defaultHorizontalMargin)
                m.top.equalTo(activityToggleView.snp.bottom).offset(Constants.defaultVerticalMargin)
                m.height.equalTo(Constants.cellHeight)
            })
            
            serviceToggleView.snp.makeConstraints({ m in
                m.left.right.equalToSuperview().inset(Constants.defaultHorizontalMargin)
                m.top.equalTo(registerToggleView.snp.bottom).offset(Constants.defaultVerticalMargin)
                m.height.equalTo(Constants.cellHeight)
            })
            
            insertDivider(before: serviceToggleView, topOffset: Constants.defaultVerticalMargin, after: inquireToggleView, bottomOffset: Constants.defaultVerticalMargin)
            
            inquireToggleView.snp.makeConstraints({ m in
                m.left.right.equalToSuperview().inset(Constants.defaultHorizontalMargin)
                m.height.equalTo(Constants.cellHeight)
            })
            
            insertDivider(before: inquireToggleView, topOffset: Constants.defaultVerticalMargin, after: usageSectionLabel, bottomOffset: Constants.defaultVerticalMargin)
            
            usageSectionLabel.snp.makeConstraints({ m in
                m.left.right.equalToSuperview().inset(Constants.defaultHorizontalMargin)
            })
        } else {
            loginButton.snp.makeConstraints({ m in
                m.top.equalToSuperview().inset(Constants.LoginButton.topMargin)
                m.centerX.equalToSuperview()
                m.left.right.equalToSuperview().inset(Constants.defaultHorizontalMargin)
                m.height.equalTo(Constants.LoginButton.height)
            })
            
            usageSectionLabel.snp.makeConstraints({ m in
                m.top.equalTo(loginButton.snp.bottom).offset(Constants.UsageInfo.sectionNonLoginTopMargin)
                m.left.right.equalToSuperview().inset(Constants.defaultHorizontalMargin)
            })
        }
        
        usagePolicyButton.snp.makeConstraints({ m in
            m.left.right.equalToSuperview().inset(Constants.defaultHorizontalMargin)
            m.top.equalTo(usageSectionLabel.snp.bottom).offset(Constants.UsageInfo.usagePolicyTopMargin)
            m.height.equalTo(Constants.cellHeight)
        })
        
        privacyPolicyButton.snp.makeConstraints({ m in
            m.left.right.equalToSuperview().inset(Constants.defaultHorizontalMargin)
            m.top.equalTo(usagePolicyButton.snp.bottom).offset(Constants.UsageInfo.privacyPolicyTopMargin)
            m.height.equalTo(Constants.cellHeight)
        })
        
        communityPolicyButton.snp.makeConstraints({ m in
            m.left.right.equalToSuperview().inset(Constants.defaultHorizontalMargin)
            m.top.equalTo(privacyPolicyButton.snp.bottom).offset(Constants.UsageInfo.communityPolicyTopMargin)
            m.height.equalTo(Constants.cellHeight)
        })
        
        insertDivider(before: communityPolicyButton, topOffset: Constants.UsageInfo.bottomDividerOffset, after: etcSectionLabel, bottomOffset: Constants.defaultVerticalMargin)
        
        etcSectionLabel.snp.makeConstraints({ m in
            m.left.right.equalToSuperview().inset(Constants.defaultHorizontalMargin)
        })
        
        noticePolicyButton.snp.makeConstraints({ m in
            m.left.right.equalToSuperview().inset(Constants.defaultHorizontalMargin)
            m.top.equalTo(etcSectionLabel.snp.bottom).offset(Constants.Etc.noticeTopMargin)
            m.height.equalTo(Constants.cellHeight)
        })
        
        if viewModel.user != nil {
            updateInfoView.snp.makeConstraints({ m in
                m.left.right.equalToSuperview().inset(Constants.defaultHorizontalMargin)
                m.top.equalTo(noticePolicyButton.snp.bottom).offset(Constants.Etc.updateTopMargin)
                m.height.equalTo(Constants.cellHeight)
            })
            
            insertDivider(before: updateInfoView, topOffset: Constants.defaultVerticalMargin, after: logoutButton, bottomOffset: Constants.Account.logoutTopMargin)
            
            logoutButton.snp.makeConstraints({ m in
                m.left.equalToSuperview().inset(Constants.defaultHorizontalMargin)
                m.height.equalTo(Constants.cellHeight)
            })
            
            deleteButton.snp.makeConstraints({ m in
                m.left.equalToSuperview().inset(Constants.defaultHorizontalMargin)
                m.top.equalTo(logoutButton.snp.bottom).offset(Constants.Account.deleteTopMargin)
                m.height.equalTo(Constants.cellHeight)
                m.bottom.equalToSuperview().offset(-Constants.Account.deletBottomMargin)
            })
        } else {
            updateInfoView.snp.makeConstraints({ m in
                m.left.right.equalToSuperview().inset(Constants.defaultHorizontalMargin)
                m.top.equalTo(noticePolicyButton.snp.bottom).offset(Constants.Etc.updateTopMargin)
                m.height.equalTo(Constants.cellHeight)
                m.bottom.equalToSuperview()
            })
        }
    }
    
    override func setupNavigationBar() {
        navigationItem.title = Constants.Navigation.title
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.rightBarButtonItem = nil
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: Constants.primaryFont
        ]
    }
    
    private func insertDivider(before: UIView, topOffset: CGFloat, after: UIView, bottomOffset: CGFloat) {
        let view = UIView()
        view.backgroundColor = Constants.Divider.color
        
        contentView.addSubview(view)
        
        view.snp.makeConstraints({ m in
            m.left.right.equalToSuperview().inset(Constants.defaultHorizontalMargin)
            m.top.equalTo(before.snp.bottom).offset(topOffset)
            m.height.equalTo(Constants.Divider.thickness)
        })
        
        after.snp.makeConstraints({ m in
            m.top.equalTo(view.snp.bottom).offset(bottomOffset)
        })
    }
}


// MARK: - ScrollView Delegate
extension MyPageSettingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.bounds.minY > 0 {
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = cancelButtonItem
        } else {
            navigationItem.leftBarButtonItem = backButtonItem
            navigationItem.rightBarButtonItem = nil
        }
    }
}


fileprivate final class SectionTitleLabel: UILabel {
    private enum Constants {
        static let font = UIFont.systemFont(ofSize: 14, weight: .regular)
        static let color = UIColor(red: 97/255, green: 97/255, blue: 97/255, alpha: 1)
    }
    
    init(title: String) {
        super.init(frame: .zero)
        text = title
        font = Constants.font
        textColor = Constants.color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


fileprivate class MyPageSettingScrollView: UIScrollView {

    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view.isKind(of: UIButton.self) {
          return true
        }

        return super.touchesShouldCancel(in: view)
    }
}
