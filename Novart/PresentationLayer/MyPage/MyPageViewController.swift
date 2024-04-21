import UIKit
import SnapKit
import Combine
import Kingfisher

final class MyPageViewController: BaseViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let screenWidth = UIScreen.main.bounds.size.width
        static let screenHeight = UIScreen.main.bounds.size.height
        
        static func getRelativeWidth(from width: CGFloat) -> CGFloat {
            Constants.screenWidth * (width/390)
        }
        static func getRelativeHeight(from height: CGFloat) -> CGFloat {
            Constants.screenHeight * (height/844)
        }
        
        static let navIconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 24, height: 24))
        static let headerTransitionHeight: CGFloat = getRelativeHeight(from: 202)
        
        static var appearance: UINavigationBarAppearance = {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .clear
            appearance.shadowColor = .clear
            return appearance
        }()
        
        enum Layout {
            static let sectionInset = UIEdgeInsets(top: 0, left: getRelativeWidth(from: 24), bottom: getRelativeWidth(from: 24), right: getRelativeWidth(from: 24)) // bottom은 임의로 추가
            static let navigationBarSpacerWidth: CGFloat = 16
        }
        
        enum CollectionView {
            static let itemSpacing: CGFloat = getRelativeWidth(from: 12)
            static let lineSpacing: CGFloat = getRelativeHeight(from: 12)
            static let bottomMargin: CGFloat = 24
        }
        
        enum CellSize {
            static let cellWidth: CGFloat = (Constants.screenWidth - 60) / 2
            
            static let InterestCellSize = CGSize(width: getRelativeWidth(from: 165), height: Constants.CellSize.cellWidth * (221/165))
            static let FollowingCellSize = CGSize(width: getRelativeWidth(from: 165), height: Constants.CellSize.cellWidth * (110/165))
            static let WorkCellSize = CGSize(width: getRelativeWidth(from: 165), height: Constants.CellSize.cellWidth * (205/165))
            static let ExhibitionCellSize = CGSize(width: getRelativeWidth(from: 342), height: (Constants.screenWidth - 48) * (525/342))
        }
        
        enum AskButton {
            static let text = "문의"
            static let backgroundColor = UIColor.Common.grey04
            static let font = UIFont.systemFont(ofSize: 16, weight: .bold)
            static let width = getRelativeWidth(from: 84)
            static let height = getRelativeHeight(from: 42)
            static let leftMargin = getRelativeWidth(from: 24)
            static let topMargin = getRelativeHeight(from: 7)
        }
        
        enum FollowButton {
            static let unFollowedText = "팔로우"
            static let followedText = "팔로잉"
            static let font = UIFont.systemFont(ofSize: 16, weight: .bold)
            static let width = getRelativeWidth(from: 250)
            static let height = getRelativeHeight(from: 42)
            static let leftMargin = getRelativeWidth(from: 8)
            static let unFollowedColor = UIColor.Common.main
            static let followedColor = UIColor.Common.grey04
        }
        
        enum FollowToastView {
            static let backgroundColor = UIColor.Common.grey01_light
            static let radius: CGFloat = 12
            static let width = getRelativeWidth(from: 342)
            static let height = getRelativeHeight(from: 52)
            
            enum IconImageView {
                static let diameter = getRelativeWidth(from: 24)
                static let leftMargin = getRelativeWidth(from: 16)
                static let iconImage = UIImage(named: "icon_follow_check")
            }
            
            enum TitleLabel {
                static let text = "새로운 작가를 팔로우했어요!"
                static let textColor = UIColor.Common.grey04
                static let font = UIFont.systemFont(ofSize: 14, weight: .medium)
                static let leftMargin = getRelativeWidth(from: 8)
            }
            
            enum ShowAllButton {
                static let text = "모두 보기"
                static let textColor = UIColor.Common.black
                static let font = UIFont.systemFont(ofSize: 14, weight: .semibold)
                static let rightMargin = getRelativeWidth(from: 10)
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
    private var cellId = ProductCell.reuseIdentifier
    private var cellType: UICollectionViewCell.Type = ProductCell.self
    private var isHeaderSticky = false
    private var isHeaderFirstSetup = true
    private var isGradient = false
    private var isOtherUserFollowing: Bool?
    
    
    // MARK: - LifeCycle
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init()
        collectionView.register(MyPageHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyPageHeaderView.reuseIdentifier)
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
            viewModel.getAllItems()
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
        viewModel.$selectedCategory.sink(receiveValue: { value in
            switch value {
            case .Interest:
                self.cellSize = Constants.CellSize.InterestCellSize
                self.cellId = ProductCell.reuseIdentifier
                self.cellType = ProductCell.self
            case .Following:
                self.cellSize = Constants.CellSize.FollowingCellSize
                self.cellId = SearchArtistCell.reuseIdentifier
                self.cellType = SearchArtistCell.self
            case .Work:
                self.cellSize = Constants.CellSize.WorkCellSize
                self.cellId = MyPageWorkCell.reuseIdentifier
                self.cellType = MyPageWorkCell.self
            case .Exhibition:
                self.cellSize = Constants.CellSize.ExhibitionCellSize
                self.cellId = MyPageExhibitionCell.reuseIdentifier
                self.cellType = MyPageExhibitionCell.self
            }
            if self.isHeaderSticky {
                self.collectionView.contentOffset = CGPoint(x: 0, y: Constants.headerTransitionHeight)
            }
            self.uploadProductButton.isHidden = (self.viewModel.userState == .me && value == .Work) ? false : true
            self.collectionView.reloadData()
        }).store(in: &cancellables)
        
        viewModel.$scrollHeight.sink(receiveValue: { value in
            if value >= Constants.headerTransitionHeight && !self.isHeaderSticky {
                self.collectionViewLayout.sectionHeadersPinToVisibleBounds = true
                self.isHeaderSticky = true
                self.collectionView.reloadData()
            } else if value < Constants.headerTransitionHeight && self.isHeaderSticky {
                self.collectionViewLayout.sectionHeadersPinToVisibleBounds = false
                self.isHeaderSticky = false
                self.collectionView.reloadData()
            }
        }).store(in: &cancellables)
        
        viewModel.$interests.sink(receiveValue: { value in
            self.collectionView.reloadData()
        }).store(in: &cancellables)
        
        viewModel.$followings.sink(receiveValue: { value in
            self.collectionView.reloadData()
        }).store(in: &cancellables)
        
        viewModel.$works.sink(receiveValue: { value in
            self.collectionView.reloadData()
        }).store(in: &cancellables)
        
        viewModel.$exhibitions.sink(receiveValue: { value in
            self.collectionView.reloadData()
        }).store(in: &cancellables)
        
        viewModel.$otherUser.sink(receiveValue: { otherUser in
            guard let otherUser else { return }
            self.isOtherUserFollowing = otherUser.following
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.followButton.backgroundColor = otherUser.following ? Constants.FollowButton.followedColor : Constants.FollowButton.unFollowedColor
                let buttonTitle = otherUser.following ? Constants.FollowButton.followedText : Constants.FollowButton.unFollowedText
                self.followButton.setTitle(buttonTitle, for: .normal)
            }
        }).store(in: &cancellables)
    }
    
    
    // MARK: - UI
    private let collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = Constants.CollectionView.itemSpacing
        layout.minimumLineSpacing = Constants.CollectionView.lineSpacing
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.delaysContentTouches = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constants.CollectionView.bottomMargin, right: 0)
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
                        print("🟢🟢🟢 공유하기(me) 🟢🟢🟢")
                    }),
                ]
            }
            
            if viewModel.userState == .other {
                return [
                    UIAction(title: "공유", image: UIImage(systemName: "square.and.arrow.up"), handler: { _ in
                        print("🟢🟢🟢 공유하기(other) 🟢🟢🟢")
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
        button.backgroundColor = Constants.AskButton.backgroundColor
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
        let view = UIView(frame: CGRect(x: (Constants.screenWidth - Constants.FollowToastView.width) / 2, y: Constants.screenHeight - 52, width: Constants.FollowToastView.width, height: Constants.FollowToastView.height))
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
            print("Show All Button Tapped")
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
        viewModel.getAllItems()
        viewModel.getOtherUserInfo()
    
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


// MARK: - CollectionView
extension MyPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(cellType, forCellWithReuseIdentifier: cellId)
        switch viewModel.selectedCategory {
        case .Interest:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ProductCell else {
                return UICollectionViewCell()
            }
            let item = viewModel.interests[indexPath.row]
            cell.update(with: item)
            return cell
        case .Following:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SearchArtistCell else {
                return UICollectionViewCell()
            }
            let item = viewModel.followings[indexPath.row]
            cell.update(with: item)
            return cell
        case .Work:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MyPageWorkCell else {
                return UICollectionViewCell()
            }
            let item = viewModel.works[indexPath.row]
            cell.update(with: item)
            return cell
        case .Exhibition:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MyPageExhibitionCell else {
                return UICollectionViewCell()
            }
            let item = viewModel.exhibitions[indexPath.row]
            cell.update(with: item)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if isHeaderSticky {
            return UIEdgeInsets(top: Constants.getRelativeHeight(from: 202 + 18), left: Constants.getRelativeWidth(from: 24), bottom: 0, right: Constants.getRelativeWidth(from: 24))
        } else {
            return UIEdgeInsets(top: 0, left: Constants.getRelativeWidth(from: 24), bottom: 0, right: Constants.getRelativeWidth(from: 24))
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        lazy var header = MyPageHeaderView()
        
        switch viewModel.userState {
        case .loggedOut:
            header.update(user: nil, userState: .loggedOut, category: viewModel.selectedCategory, isEmpty: false)
        case .other, .me:
            header.isHeaderSticky = isHeaderSticky
            if isHeaderSticky == true {
                return CGSize(width: collectionView.bounds.width, height: Constants.getRelativeHeight(from: 202))
            }
            
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
            if viewModel.userState == .me {
                header.update(user: Authentication.shared.user, userState: .me, category: viewModel.selectedCategory, isEmpty: isEmpty)
            } else if viewModel.userState == .other {
                header.update(user: viewModel.otherUser, userState: .other, category: viewModel.selectedCategory, isEmpty: isEmpty)
            }
        }
        return header.systemLayoutSizeFitting(.init(width: collectionView.bounds.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
                  let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: MyPageHeaderView.reuseIdentifier,
                    for: indexPath
                  ) as? MyPageHeaderView else {return UICollectionReusableView()}
        
        header.delegate = self
        header.isHeaderSticky = isHeaderSticky
        
        switch viewModel.userState {
        case .loggedOut:
            header.update(user: nil, userState: .loggedOut, category: viewModel.selectedCategory, isEmpty: false)
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
            
            if viewModel.userState == .me {
                header.update(user: Authentication.shared.user, userState: .me, category: viewModel.selectedCategory, isEmpty: isEmpty)
            } else if viewModel.userState == .other {
                header.update(user: viewModel.otherUser, userState: .other, category: viewModel.selectedCategory, isEmpty: isEmpty)
            }
            
            if isHeaderFirstSetup {
                header.workButton.setState(true)
            }
        }
        
        isHeaderFirstSetup = false
        
        header.onTapCategoryButton = ({ category in
            if self.viewModel.userState == .loggedOut { return }
            self.viewModel.setCategory(category)
            for e in header.categoryButtons {
                if e.category == category {
                    e.setState(true)
                } else {
                    e.setState(false)
                }
            }
        })
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
        scrollView.bounces = (scrollView.contentOffset.y > 10)
        viewModel.setScrollHeight(collectionView.bounds.minY)
    }
}


// MARK: - HeaderView
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
}
