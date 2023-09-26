import UIKit
import SnapKit
import Combine

final class MyPageViewController: BaseViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let screenWidth = UIScreen.main.bounds.width
        static var appearance: UINavigationBarAppearance = {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .clear
            appearance.shadowColor = .clear
            return appearance
        }()
        
        enum Layout {
            static let headerSize = CGSize(width: Constants.screenWidth, height: 394)
            static let sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        }
        
        enum CellSize {
            static let InterestCellSize = CGSize(width: 165, height: 221)
            static let FollowingCellSize = CGSize(width: 165, height: 110)
            static let WorkCellSize = CGSize(width: 165, height: 205)
            static let ExhibitionCellSize = CGSize(width: 165, height: 276)
        }
        
        enum CellId {
            static let InterestCellId = "\(MyPageCategory.Interest.rawValue)_cell"
            static let FollowingCellId = "\(MyPageCategory.Following.rawValue)_cell"
            static let WorkCellId = "\(MyPageCategory.Work.rawValue)_cell"
            static let ExhibitionCellId = "\(MyPageCategory.Exhibition.rawValue)_cell"
        }
    }
    
    
    // MARK: - Properties
    private let viewModel = MyPageViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var cellSize = Constants.CellSize.InterestCellSize
    private var cellCount = 0
    private var cellId = Constants.CellId.InterestCellId
    private var cellType: UICollectionViewCell.Type = MyPageInterestCell.self
    private var isHeaderSticky = false
    
    
    // MARK: - UI
    private let collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    override func setupNavigationBar() {
        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 24, height: 24))

        let notificationButton = UIButton(frame: iconSize)
        notificationButton.setBackgroundImage(UIImage(named: "icon_notification2"), for: .normal) // 기존 icon_notification이 존재해서 숫자 2를 붙임. 기존 아이콘 사용 안하는거면 수정이 필요합니다
        notificationButton.addTarget(self, action: #selector(onTapNotification), for: .touchUpInside)
        let notificationItem = UIBarButtonItem(customView: notificationButton)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 16 // figma에서는 16인데, 기본으로 들어가는 space가 있어서 12로 함
        
        let settingButton = UIButton(frame: iconSize)
        settingButton.setBackgroundImage(UIImage(named: "icon_setting"), for: .normal)
        settingButton.addTarget(self, action: #selector(onTapSetting), for: .touchUpInside)
        let settingItem = UIBarButtonItem(customView: settingButton)

        let meatballsButton = UIButton(frame: iconSize)
        meatballsButton.setBackgroundImage(UIImage(named: "icon_meatballs"), for: .normal)
        meatballsButton.addTarget(self, action: #selector(onTapMeatballs), for: .touchUpInside)
        let meatballsItem = UIBarButtonItem(customView: meatballsButton)
        
        self.navigationItem.rightBarButtonItems = [settingItem, spacer, notificationItem]
        self.navigationItem.leftBarButtonItem = meatballsItem
    }
    
    override func setupView() {
        viewModel.getUserInfo()
        viewModel.getAllItems()
        
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MyPageInterestCell.self, forCellWithReuseIdentifier: MyPageCategory.Interest.rawValue)
        collectionView.register(MyPageHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyPageHeaderView.id)
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints({ m in
            m.left.right.top.bottom.equalTo(view)
        })
    }
    
    
    // MARK: - LifeCycle
    override func setupBindings() {
        viewModel.$selectedCategory.sink(receiveValue: { value in
            switch value {
            case .Interest:
                self.cellSize = Constants.CellSize.InterestCellSize
                self.cellCount = self.viewModel.interests.count
                self.cellId = Constants.CellId.InterestCellId
                self.cellType = MyPageInterestCell.self
            case .Following:
                self.cellSize = Constants.CellSize.FollowingCellSize
                self.cellCount = self.viewModel.followings.count
                self.cellId = Constants.CellId.FollowingCellId
                self.cellType = MyPageFollowingCell.self
            case .Work:
                self.cellSize = Constants.CellSize.WorkCellSize
                self.cellCount = self.viewModel.works.count
                self.cellId = Constants.CellId.WorkCellId
                self.cellType = MyPageWorkCell.self
            case .Exhibition:
                self.cellSize = Constants.CellSize.ExhibitionCellSize
                self.cellCount = self.viewModel.exhibitions.count
                self.cellId = Constants.CellId.ExhibitionCellId
                self.cellType = MyPageExhibitionCell.self
            }
            self.collectionView.reloadData()
        }).store(in: &cancellables)
        
        viewModel.$scrollHeight.sink(receiveValue: { value in
            if value >= 180 && !self.isHeaderSticky {
                self.collectionViewLayout.sectionHeadersPinToVisibleBounds = true
                self.isHeaderSticky = true
                self.collectionView.reloadData()
            } else if value < 180 && self.isHeaderSticky {
                self.collectionViewLayout.sectionHeadersPinToVisibleBounds = false
                self.isHeaderSticky = false
                self.collectionView.reloadData()
            }
        }).store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Constants.appearance.backgroundColor = .clear
        navigationController?.navigationBar.compactAppearance = Constants.appearance
        navigationController?.navigationBar.standardAppearance = Constants.appearance
        navigationController?.navigationBar.scrollEdgeAppearance = Constants.appearance
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Constants.appearance.backgroundColor = .white
        navigationController?.navigationBar.compactAppearance = Constants.appearance
        navigationController?.navigationBar.standardAppearance = Constants.appearance
        navigationController?.navigationBar.scrollEdgeAppearance = Constants.appearance
    }
    
    
    // MARK: - Selectors
    @objc private func onTapNotification() {
        print("Notification Button Tapped")
    }
    
    @objc private func onTapSetting() {
        print("Setting Button Tapped")
    }
    
    @objc private func onTapMeatballs() {
        print("Meatballs Button Tapped")
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MyPageInterestCell else {
                return UICollectionViewCell()
            }
            cell.interest = viewModel.interests[indexPath.row]
            return cell
        case .Following:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MyPageFollowingCell else {
                return UICollectionViewCell()
            }
            return cell
        case .Work:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MyPageWorkCell else {
                return UICollectionViewCell()
            }
            return cell
        case .Exhibition:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MyPageExhibitionCell else {
                return UICollectionViewCell()
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.Layout.sectionInset
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return Constants.Layout.headerSize
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
                  let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: MyPageHeaderView.id,
                    for: indexPath
                  ) as? MyPageHeaderView else {return UICollectionReusableView()}
        
        header.isHeaderSticky = isHeaderSticky
        header.userNameLabel.text = "게스트"
        header.backgroundImageView.image = UIImage(named: "default_user_background_image")
        header.profileImageView.image = UIImage(named: "default_user_profile_image")
        
        header.onTapCategoryButton = ({ category in
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.setScrollHeight(collectionView.bounds.minY)
    }
}
