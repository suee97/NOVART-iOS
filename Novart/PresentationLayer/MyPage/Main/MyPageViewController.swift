import UIKit
import SnapKit
import Combine
import Kingfisher

final class MyPageViewController: BaseViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let screenWidth = UIScreen.main.bounds.size.width
        static let screenHeight = UIScreen.main.bounds.size.height
        
        static let navIconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 24, height: 24))
        static let headerTransitionHeight: CGFloat = 230 - 47
        
        static var appearance: UINavigationBarAppearance = {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .clear
            appearance.shadowColor = .clear
            return appearance
        }()
        
        enum Layout {
            static let sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 24, right: 24) // bottom은 임의로 추가
            static let navigationBarSpacerWidth: CGFloat = 16
        }
        
        enum CollectionView {
            static let itemSpacing: CGFloat = 12
            static let lineSpacing: CGFloat = 12
            static let bottomMargin: CGFloat = 24
        }
        
        enum CellSize {
            private static let InterestCellWidth = (Constants.screenWidth - 60) / 2
            private static let InterestCellHeight = InterestCellWidth * (221 / 165)
            private static let FollowingCellWidth = (Constants.screenWidth - 60) / 2
            private static let FollowingCellHeight = FollowingCellWidth * (110 / 165)
            private static let WorkCellWidth = (Constants.screenWidth - 60) / 2
            private static let WorkCellHeight = WorkCellWidth * (205 / 165)
            private static let ExhibitionCellWidth = Constants.screenWidth - 48
            private static let ExhibitionCellHeight = ExhibitionCellWidth * (528 / 342)
            
            static let InterestCellSize = CGSize(width: InterestCellWidth, height: InterestCellHeight)
            static let FollowingCellSize = CGSize(width: FollowingCellWidth, height: FollowingCellHeight)
            static let WorkCellSize = CGSize(width: WorkCellWidth, height: WorkCellHeight)
            static let ExhibitionCellSize = CGSize(width: ExhibitionCellWidth, height: ExhibitionCellHeight)
        }
        
        enum AskButton {
            static let text = "문의"
            static let activeBackgroundColor = UIColor.Common.grey04
            static let activeTextColor = UIColor.Common.white
            static let inActiveBackgroundColor = UIColor.Common.grey01
            static let inActiveTextColor = UIColor.Common.grey00
            static let font = UIFont.systemFont(ofSize: 16, weight: .bold)
            static let width = 84
            static let height = 42
            static let leftMargin = 24
            static let topMargin = 7
        }
        
        enum FollowButton {
            static let unFollowedText = "팔로우"
            static let followedText = "팔로잉"
            static let font = UIFont.systemFont(ofSize: 16, weight: .bold)
            static let width = 250
            static let height = 42
            static let leftMargin = 8
            static let unFollowedColor = UIColor.Common.main
            static let followedColor = UIColor.Common.grey04
        }
        
        enum FollowToastView {
            static let backgroundColor = UIColor.Common.grey01_light
            static let radius: CGFloat = 12
            static let width = 342
            static let height = 52
            
            enum IconImageView {
                static let diameter = 24
                static let leftMargin = 16
                static let iconImage = UIImage(named: "icon_follow_check")
            }
            
            enum TitleLabel {
                static let text = "새로운 작가를 팔로우했어요!"
                static let textColor = UIColor.Common.grey04
                static let font = UIFont.systemFont(ofSize: 14, weight: .medium)
                static let leftMargin = 8
            }
            
            enum ShowAllButton {
                static let text = "모두 보기"
                static let textColor = UIColor.Common.black
                static let font = UIFont.systemFont(ofSize: 14, weight: .semibold)
                static let rightMargin = 10
            }
        }
        
        enum UploadButton {
            static let size: CGFloat = 50
            static let backgrounColor: UIColor = UIColor.Common.main
            static let bottomMargin: CGFloat = 12
            static let shadowColor = UIColor.black.cgColor
            static let shadowOpacity: Float = 0.12
            static let shadowOffset = CGSize.zero
            static let shadowRadius: CGFloat = 6
        }
    }
    
    
    // MARK: - Properties
    private let viewModel: MyPageViewModel
    private var cancellables = Set<AnyCancellable>()
    private var cellSize = Constants.CellSize.InterestCellSize
    private var cellCount: Int {
        return self.viewModel.getItemCount()
    }
    private var cellType: UICollectionViewCell.Type = ProductCell.self
    private var isHeaderSticky = false
    private var isHeaderFirstSetup = true
    private var isGradient = false
    private var isOtherUserFollowing: Bool?
    private var headerHeight: CGFloat = 0
    private var transitionScrollHeight: CGFloat?
    
    
    // MARK: - LifeCycle
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Constants.appearance.backgroundColor = .clear
        navigationController?.navigationBar.compactAppearance = Constants.appearance
        navigationController?.navigationBar.standardAppearance = Constants.appearance
        navigationController?.navigationBar.scrollEdgeAppearance = Constants.appearance
        navigationController?.navigationBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        
        if viewModel.userState == .other {
            if let tab = tabBarController {
                let backgroundView = UIView(frame: tab.tabBar.frame)
                backgroundView.layer.cornerRadius = 12
                backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                backgroundView.layer.borderColor = UIColor.Common.grey01.cgColor
                backgroundView.layer.borderWidth = 0.5
                backgroundView.backgroundColor = .white
                backgroundView.tag = 2000
                
                backgroundView.addSubview(askButton)
                backgroundView.addSubview(followButton)
                askButton.snp.makeConstraints({ m in
                    m.left.equalToSuperview().inset(Constants.AskButton.leftMargin)
                    m.top.equalToSuperview().inset(Constants.AskButton.topMargin)
                    m.width.equalTo(Constants.AskButton.width)
                    m.height.equalTo(Constants.AskButton.height)
                })
                followButton.snp.makeConstraints({ m in
                    m.centerY.equalTo(askButton)
                    m.left.equalTo(askButton.snp.right).offset(Constants.FollowButton.leftMargin)
                    m.width.equalTo(Constants.FollowButton.width)
                    m.height.equalTo(Constants.FollowButton.height)
                })
                
                tab.view.addSubview(backgroundView)
            }
        } else if viewModel.userState == .me,
                  !viewModel.isStartAsPush,
                  viewModel.isInitialLoadFinished {
            viewModel.setupData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Constants.appearance.backgroundColor = .white
        navigationController?.navigationBar.compactAppearance = Constants.appearance
        navigationController?.navigationBar.standardAppearance = Constants.appearance
        navigationController?.navigationBar.scrollEdgeAppearance = Constants.appearance
        if let tab = tabBarController {
            for v in tab.view.subviews {
                if v.tag == 2000 {
                    v.removeFromSuperview()
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !isGradient {
            addGradient()
            isGradient = true
        }
    }

    
    // MARK: - Binding
    override func setupBindings() {
        viewModel.$selectedCategory
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let self else { return }
                switch value {
                case .Interest:
                    self.cellSize = Constants.CellSize.InterestCellSize
                    self.cellType = ProductCell.self
                case .Following:
                    self.cellSize = Constants.CellSize.FollowingCellSize
                    self.cellType = SearchArtistCell.self
                case .Work:
                    self.cellSize = Constants.CellSize.WorkCellSize
                    self.cellType = MyPageWorkCell.self
                case .Exhibition:
                    self.cellSize = Constants.CellSize.ExhibitionCellSize
                    self.cellType = MyPageExhibitionCell.self
                }
                if self.isHeaderSticky {
                    self.collectionView.contentOffset = CGPoint(x: 0, y: 220)
                }
                self.uploadProductButton.isHidden = (self.viewModel.userState == .me && value == .Work) ? false : true
                
                self.collectionView.reloadData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if let header = self.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? MyPageHeaderView {
                        for button in header.categoryButtons {
                            if button.category == value {
                                button.setState(true)
                            } else {
                                button.setState(false)
                            }
                        }
                    }
                }
        }).store(in: &cancellables)
        
        viewModel.shouldReloadCollectionViewSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                self.collectionView.reloadData()
            }).store(in: &cancellables)
        
        viewModel.$otherUser
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] otherUser in
                guard let self, let otherUser else { return }
                self.isOtherUserFollowing = otherUser.following
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.followButton.backgroundColor = otherUser.following ? Constants.FollowButton.followedColor : Constants.FollowButton.unFollowedColor
                    let buttonTitle = otherUser.following ? Constants.FollowButton.followedText : Constants.FollowButton.unFollowedText
                    self.followButton.setTitle(buttonTitle, for: .normal)
                    if self.viewModel.isUserCanContact(openChatUrl: otherUser.openChatUrl, email: otherUser.email) {
                        self.askButton.setTitleColor(Constants.AskButton.activeTextColor, for: .normal)
                        self.askButton.backgroundColor = Constants.AskButton.activeBackgroundColor
                    } else {
                        self.askButton.setTitleColor(Constants.AskButton.inActiveTextColor, for: .normal)
                        self.askButton.backgroundColor = Constants.AskButton.inActiveBackgroundColor
                    }
                }
        }).store(in: &cancellables)
        
        viewModel.notificationCheckStatusSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] notificationCheckStatus in
            guard let self else { return }
            let iconPath = notificationCheckStatus.unread ? "icon_notification_unread" : "icon_notification2"
            self.notificationButton.setBackgroundImage(UIImage(named: iconPath), for: .normal)
        }).store(in: &cancellables)
    }
    
    
    // MARK: - UI
    private let collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = Constants.CollectionView.itemSpacing
        layout.minimumLineSpacing = Constants.CollectionView.lineSpacing
        layout.sectionInset = UIEdgeInsets(top: 18, left: 24, bottom: 24, right: 24)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.delaysContentTouches = false
        collectionView.register(MyPageHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyPageHeaderView.reuseIdentifier)
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseIdentifier)
        collectionView.register(SearchArtistCell.self, forCellWithReuseIdentifier: SearchArtistCell.reuseIdentifier)
        collectionView.register(MyPageWorkCell.self, forCellWithReuseIdentifier: MyPageWorkCell.reuseIdentifier)
        collectionView.register(MyPageExhibitionCell.self, forCellWithReuseIdentifier: MyPageExhibitionCell.reuseIdentifier)
        if viewModel.userState == .loggedOut { collectionView.isScrollEnabled = false }
        return collectionView
    }()
    
    private lazy var meatballsMenu: UIMenu = {
        let menuItems: [UIAction] = {
            if viewModel.userState == .me {
                return [
                    UIAction(title: "프로필 편집", image: UIImage(systemName: "person"), handler: { [weak self] _ in
                        guard let self else { return }
                        if self.viewModel.userState == .me {
                            self.viewModel.showProfileEdit()
                        }
                    }),
                    UIAction(title: "공유", image: UIImage(systemName: "square.and.arrow.up"), handler: { _ in
                        guard let myId = Authentication.shared.user?.id else { return }
                        let dataToShare = "https://\(URLSchemeFactory.plainURLScheme).com/profile/\(myId)"
                        let activityController = ActivityController(activityItems: [dataToShare], applicationActivities: nil)
                        activityController.show()
                    }),
                ]
            }
            
            if viewModel.userState == .other {
                return [
                    UIAction(title: "공유", image: UIImage(systemName: "square.and.arrow.up"), handler: { [weak self] _ in
                        guard let self, let profileId = self.viewModel.userId else { return }
                        let dataToShare = "https://\(URLSchemeFactory.plainURLScheme).com/profile/\(profileId)"
                        let activityController = ActivityController(activityItems: [dataToShare], applicationActivities: nil)
                        activityController.show()
                    }),
                    UIAction(title: "사용자 차단", image: UIImage(named: "icon_block"), handler: { [weak self] _ in
                        guard let self else { return }
                        self.onTapUserBlock()
                    }),
                    UIAction(title: "신고", image: UIImage(systemName: "exclamationmark.triangle"), attributes: [.destructive],  handler: { [weak self] _ in
                        guard let self else { return }
                        self.onTapReport()
                    })
                ]
            }
            
            return []
        }()
        
        let menu: UIMenu = UIMenu(options: [], children: menuItems)
        return menu
    }()
    
    private lazy var meatballsButton: UIButton = {
        let button = UIButton(frame: Constants.navIconSize)
        button.setBackgroundImage(UIImage(named: "icon_meatballs"), for: .normal)
        button.showsMenuAsPrimaryAction = true
        
        switch viewModel.userState {
        case .other:
            button.menu = meatballsMenu
        case .loggedOut:
            button.addAction(UIAction(handler: { [weak self] _ in
                guard let self else { return }
                self.viewModel.showLoginModal()
            }), for: .touchUpInside)
        case .me:
            button.menu = meatballsMenu
        }
        
        return button
    }()
    
    private lazy var notificationButton: UIButton = {
        let button = UIButton(frame: Constants.navIconSize)
        button.setBackgroundImage(UIImage(named: "icon_notification2"), for: .normal) // 기존 icon_notification이 존재해서 숫자 2를 붙임. 기존 아이콘 사용 안하는거면 수정이 필요합니다
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            if self.viewModel.userState == .me {
                self.viewModel.showNotification()
            }
            if self.viewModel.userState == .loggedOut {
                self.viewModel.showLoginModal()
            }
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var settingButton: UIButton = {
        let button = UIButton(frame: Constants.navIconSize)
        button.setBackgroundImage(UIImage(named: "icon_setting"), for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.showSetting()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(frame: Constants.navIconSize)
        button.setBackgroundImage(UIImage(named: "icon_back"), for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
            self.viewModel.close()
        }), for: .touchUpInside)
        return button
    }()
    
    override func setupNavigationBar() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = Constants.Layout.navigationBarSpacerWidth
        
        let notificationItem = UIBarButtonItem(customView: notificationButton)
        let settingItem = UIBarButtonItem(customView: settingButton)
        let meatballsItem = UIBarButtonItem(customView: meatballsButton)
        let backItem = UIBarButtonItem(customView: backButton)
        
        if viewModel.userState == .other {
            self.navigationItem.rightBarButtonItems = [meatballsItem]
            self.navigationItem.leftBarButtonItem = backItem
        } else if viewModel.isStartAsPush {
            self.navigationItem.rightBarButtonItems = [meatballsItem, spacer, notificationItem]
            self.navigationItem.leftBarButtonItem = backItem
        } else {
            self.navigationItem.rightBarButtonItems = [meatballsItem, spacer, notificationItem]
            self.navigationItem.leftBarButtonItem = settingItem
        }
    }
    
     lazy var askButton: PlainButton = {
        let button = PlainButton()
        button.setTitle(Constants.AskButton.text, for: .normal)
        button.titleLabel?.font = Constants.AskButton.font
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.onTapAskButton()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var followButton: PlainButton = {
        let button = PlainButton()
        button.backgroundColor = .clear
        button.titleLabel?.font = Constants.FollowButton.font
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.onTapFollowButton()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var followToastView: UIView = {
        let view = UIView(frame: CGRect(x: (Int(Constants.screenWidth) - Constants.FollowToastView.width) / 2, y: Int(Constants.screenHeight) - 52, width: Constants.FollowToastView.width, height: Constants.FollowToastView.height))
        view.backgroundColor = Constants.FollowToastView.backgroundColor
        view.layer.cornerRadius = Constants.FollowToastView.radius
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.masksToBounds = false
        
        let iconImageView = UIImageView(image: Constants.FollowToastView.IconImageView.iconImage)
        let titleLabel = UILabel()
        titleLabel.text = Constants.FollowToastView.TitleLabel.text
        titleLabel.textColor = Constants.FollowToastView.TitleLabel.textColor
        titleLabel.font = Constants.FollowToastView.TitleLabel.font
        let showAllButton = UIButton()
        showAllButton.setTitle(Constants.FollowToastView.ShowAllButton.text, for: .normal)
        showAllButton.titleLabel?.font = Constants.FollowToastView.ShowAllButton.font
        showAllButton.setTitleColor(Constants.FollowToastView.ShowAllButton.textColor, for: .normal)
        showAllButton.addAction(UIAction(handler: { _ in
            print("Show All Button Tapped") // TODO: 여기 개발 해야함
        }), for: .touchUpInside)
        
        view.addSubview(iconImageView)
        view.addSubview(titleLabel)
        view.addSubview(showAllButton)
        
        iconImageView.snp.makeConstraints({ m in
            m.centerY.equalToSuperview()
            m.left.equalToSuperview().inset(Constants.FollowToastView.IconImageView.leftMargin)
            m.width.height.equalTo(Constants.FollowToastView.IconImageView.diameter)
        })
        titleLabel.snp.makeConstraints({ m in
            m.left.equalTo(iconImageView.snp.right).offset(Constants.FollowToastView.TitleLabel.leftMargin)
            m.centerY.equalToSuperview()
        })
        showAllButton.snp.makeConstraints({ m in
            m.centerY.equalToSuperview()
            m.right.equalToSuperview().inset(Constants.FollowToastView.ShowAllButton.rightMargin)
        })
        
        view.isHidden = true
        return view
    }()
    
    private lazy var uploadProductButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.Common.main
        button.setImage(UIImage(named: "icon_upload_plus"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: Constants.UploadButton.size),
            button.heightAnchor.constraint(equalToConstant: Constants.UploadButton.size)
        ])
        button.layer.cornerRadius = Constants.UploadButton.size / 2
        
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self, self.viewModel.userState == .me else { return }
            self.viewModel.showProductUploadScene()
        }), for: .touchUpInside)
        
        button.layer.shadowColor = Constants.UploadButton.shadowColor
        button.layer.shadowOpacity = Constants.UploadButton.shadowOpacity
        button.layer.shadowOffset = Constants.UploadButton.shadowOffset
        button.layer.shadowRadius = Constants.UploadButton.shadowRadius
        button.isHidden = true
        return button
    }()
    
    override func setupView() {
        viewModel.setupData()
        viewModel.fetchOtherUserInfo()
    
        let safeArea = view.safeAreaLayoutGuide
        
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        view.addSubview(followToastView)
        view.addSubview(uploadProductButton)
        
        collectionView.snp.makeConstraints({ m in
            m.left.right.top.bottom.equalTo(view)
        })
        
        uploadProductButton.snp.makeConstraints { m in
            m.bottom.equalTo(safeArea).inset(Constants.UploadButton.bottomMargin)
            m.centerX.equalToSuperview()
        }
    }
    
    
    // MARK: - Functions
    private func onTapAskButton() {
        viewModel.showAskSheet()
    }
    
    private func onTapFollowButton() {
        guard let _ = Authentication.shared.user, let otherUser = viewModel.otherUser else { return }

        Task {
            if otherUser.following {
                do {
                    let _ = try await viewModel.unFollow(userId: otherUser.id)
                    viewModel.otherUser?.following = false
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                do {
                    let _ = try await viewModel.follow(userId: otherUser.id)
                    viewModel.otherUser?.following = true
                    
                    if !followToastView.isHidden { return }
                    showFollowToastView()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        self.hideFollowToastView()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func showFollowToastView() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn],
                       animations: {
            self.followToastView.center.y = self.view.frame.maxY - 52
            self.followToastView.layoutIfNeeded()
        }, completion: nil)
        
        followToastView.isHidden = false
    }
    
    private func hideFollowToastView() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveLinear],
                       animations: {
            self.followToastView.center.y = Constants.screenHeight - 52
            self.followToastView.layoutIfNeeded()
        },  completion: {(_ completed: Bool) -> Void in
            self.followToastView.isHidden = true
        })
    }
    
    private func onTapReport() {
        viewModel.showReportSheet()
    }
    
    private func onTapUserBlock() {
        viewModel.showBlockSheet()
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        let colors: [CGColor] = [UIColor.white.withAlphaComponent(0.5).cgColor, UIColor.white.withAlphaComponent(0.0).cgColor]
        gradientLayer.colors = colors

        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.16)
        view.layer.addSublayer(gradientLayer)
    }
}


// MARK: - CollectionView + HeaderView
extension MyPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.selectedCategory {
        case .Interest:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.reuseIdentifier, for: indexPath) as? ProductCell else {
                return UICollectionViewCell()
            }
            let item = viewModel.interests[indexPath.row]
            cell.update(with: item)
            return cell
        case .Following:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchArtistCell.reuseIdentifier, for: indexPath) as? SearchArtistCell else {
                return UICollectionViewCell()
            }
            let item = viewModel.followings[indexPath.row]
            cell.update(with: item)
            return cell
        case .Work:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageWorkCell.reuseIdentifier, for: indexPath) as? MyPageWorkCell else {
                return UICollectionViewCell()
            }
            let item = viewModel.works[indexPath.row]
            cell.update(with: item)
            return cell
        case .Exhibition:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageExhibitionCell.reuseIdentifier, for: indexPath) as? MyPageExhibitionCell else {
                return UICollectionViewCell()
            }
            let item = viewModel.exhibitions[indexPath.row]
            cell.update(with: item)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        lazy var header = MyPageHeaderView()
        updateHeaderView(with: header)
        let headerSize = header.systemLayoutSizeFitting(.init(width: collectionView.bounds.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        if !self.isHeaderSticky { self.headerHeight = headerSize.height }
        return headerSize
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader, let header = collectionView.dequeueReusableSupplementaryView( ofKind: kind, withReuseIdentifier: MyPageHeaderView.reuseIdentifier, for: indexPath ) as? MyPageHeaderView else { return UICollectionReusableView() }
        
        header.delegate = self

        updateHeaderView(with: header)
        
        if viewModel.userState == .me || viewModel.userState == .other {
            if isHeaderFirstSetup {
                header.workButton.setState(true)
            }
        }
        isHeaderFirstSetup = false
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.userState == .loggedOut { return }
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
        
        switch viewModel.selectedCategory {
        case .Interest:
            let item = viewModel.interests[indexPath.row]
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.viewModel.presentProductDetailScene(productId: item.id)
            }
        case .Following:
            let item = viewModel.followings[indexPath.row]
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.viewModel.showArtistProfile(userId: item.id)
            }
        case .Work:
            let item = viewModel.works[indexPath.row]
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.viewModel.presentProductDetailScene(productId: item.id)
            }
        case .Exhibition:
            let item = viewModel.exhibitions[indexPath.row]
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.viewModel.showExhibitionDetail(exhibitionId: item.id)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = (scrollView.contentOffset.y > 10) // 상단 스크롤 방지
        
        let headerBottomPositionFromWindow = getHeaderBottomPositionFromWindow()
        guard let headerBottomPositionFromWindow else { return }
        let scrollHeight = scrollView.contentOffset.y
        if !isHeaderSticky && headerBottomPositionFromWindow <= 195 {
            isHeaderSticky = true
            guard let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? MyPageHeaderView else { return }
            updateHeaderView(with: header)
            collectionViewLayout.sectionHeadersPinToVisibleBounds = true
            transitionScrollHeight = scrollHeight
            collectionViewLayout.sectionInset = UIEdgeInsets(top: scrollHeight + 12, left: 24, bottom: 24, right: 24)
            collectionView.collectionViewLayout.invalidateLayout()
            return
        }
        
        if let transitionScrollHeight, isHeaderSticky, scrollHeight < transitionScrollHeight {
            isHeaderSticky = false
            guard let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? MyPageHeaderView else { return }
            updateHeaderView(with: header)
            collectionViewLayout.sectionHeadersPinToVisibleBounds = false
            collectionViewLayout.sectionInset = UIEdgeInsets(top: 18, left: 24, bottom: 24, right: 24)
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    private func getHeaderBottomPositionFromWindow() -> CGFloat? {
        guard let window = self.view.window else { return nil }
        guard let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? MyPageHeaderView else { return nil }
        let frame = window.convert(header.frame, from: collectionView)
        return frame.maxY
    }
    
    func updateHeaderView(with header: MyPageHeaderView) {
        switch self.viewModel.userState {
        case .loggedOut:
            header.updateHeaderView(user: nil, userState: .loggedOut, category: viewModel.selectedCategory, isContentsEmpty: false, isSticky: isHeaderSticky)
        case .other, .me:
            var isEmpty: Bool = false
            switch viewModel.selectedCategory {
            case .Following:
                isEmpty = viewModel.isFollowingsEmpty
            case .Interest:
                isEmpty = viewModel.isInterestsEmpty
            case .Exhibition:
                isEmpty = viewModel.exhibitions.isEmpty
            case .Work:
                isEmpty = viewModel.works.isEmpty
            }
            if self.viewModel.userState == .me {
                header.updateHeaderView(user: Authentication.shared.user, userState: .me, category: viewModel.selectedCategory, isContentsEmpty: isEmpty, isSticky: isHeaderSticky)
            } else if self.viewModel.userState == .other {
                header.updateHeaderView(user: viewModel.otherUser, userState: .other, category: viewModel.selectedCategory, isContentsEmpty: isEmpty, isSticky: isHeaderSticky)
            }
        }
    }
}


// MARK: - HeaderView Delegate
extension MyPageViewController: MyPageHeaderViewDelegate {
    func onTapLoginButton() {
        viewModel.showLoginModal()
    }
    
    func onTapProfileImage() {
        if viewModel.userState == .me {
            viewModel.showProfileEdit()
        }
    }
    
    func onTapProfileLabel() {
        if viewModel.userState == .me {
            viewModel.showProfileEdit()
        }
    }
    
    func onTapCategoryButton(header: MyPageHeaderView, selectedCategory: MyPageCategory) {
        if viewModel.userState == .loggedOut || viewModel.selectedCategory == selectedCategory { return }
        viewModel.setCategory(selectedCategory)
        for button in header.categoryButtons {
            let state = (button.category == selectedCategory)
            button.setState(state)
        }
    }
}
