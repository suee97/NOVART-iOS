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
        enum CellSize {
            static let InterestCellSize = CGSize(width: 165, height: 221)
            static let FollowingCellSize = CGSize(width: 165, height: 110)
            static let WorkCellSize = CGSize(width: 165, height: 205)
            static let ExhibitionCellSize = CGSize(width: 165, height: 276)
        }
    }
    
    
    // MARK: - Properties
    private let viewModel = MyPageViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var headerSize: CGSize = .init(width: Constants.screenWidth, height: 382+12)
    private var cellSize = CGSize(width: 165, height: 221)
    
    
    // MARK: - UI
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        spacer.width = 16 // figma에서는 20인데, 기본으로 들어가는 space가 있어서 16으로 함
        
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
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(MyPageHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyPageHeaderView.id)
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints({ m in
            m.left.right.top.bottom.equalTo(view)
        })
    }
    
    
    // MARK: - LifeCycle
    override func setupBindings() {
        viewModel.$selectedCategory.sink(receiveValue: { value in
            switch value! {
            case .Interest:
                self.cellSize = Constants.CellSize.InterestCellSize
            case .Following:
                self.cellSize = Constants.CellSize.FollowingCellSize
            case .Work:
                self.cellSize = Constants.CellSize.WorkCellSize
            case .Exhibition:
                self.cellSize = Constants.CellSize.ExhibitionCellSize
            }
            self.collectionView.reloadData()
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        cell.backgroundColor = .gray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return headerSize
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
                  let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: MyPageHeaderView.id,
                    for: indexPath
                  ) as? MyPageHeaderView else {return UICollectionReusableView()}
        
        header.userNameLabel.text = "게스트"
        header.backgroundImageView.image = UIImage(named: "default_user_background_image")
        header.profileImageView.image = UIImage(named: "default_user_profile_image")
        
        header.onTap = ({ category in
            self.viewModel.setCategory(category)
        })
        
        return header
    }
}
