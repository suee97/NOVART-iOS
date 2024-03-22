import UIKit
import SnapKit
import Combine

final class MyPageNotificationViewController: BaseViewController {

    // MARK: - Constants
    private enum Constants {
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        static let backgroundColor: UIColor = .Common.white
        
        enum Navigation {
            static let titleText = "알림"
            static let titleFont: UIFont = .systemFont(ofSize: 16, weight: .bold)
            static let titleColor: UIColor = .Common.black
            static let backButtonSize = CGSize(width: 24, height: 24)
        }
        
        enum CollectionView {
            static let cellWidth: CGFloat = Constants.screenWidth - 16
            static let cellSpacing: CGFloat = 0
        }
    }
    
    
    // MARK: - Properties
    private var viewModel: MyPageNotificationViewModel
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - LifeCycle
    init(viewModel: MyPageNotificationViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupBindings() {
        viewModel.$notifications.sink(receiveValue: { value in
            print("📣 notification 개수: \(value.count)")
            self.collectionView.reloadData()
        }).store(in: &cancellables)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.initNotifications()
        viewModel.fetchNotifications(notificationId: 0)
    }
    
    // MARK: - UI
    private lazy var backButtonItem: UIBarButtonItem = {
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: Constants.Navigation.backButtonSize))
        button.setBackgroundImage(UIImage(named: "icon_back"), for: .normal)
        button.addAction(UIAction(handler: { _ in
            self.viewModel.showMain()
        }), for: .touchUpInside)
        let item = UIBarButtonItem(customView: button)
        return item
    }()
    
    override func setupNavigationBar() {
        navigationItem.title = Constants.Navigation.titleText
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.rightBarButtonItem = nil
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: Constants.Navigation.titleFont,
            .foregroundColor: UIColor.red
        ]
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.CollectionView.cellSpacing
        layout.estimatedItemSize = CGSize(width: Constants.screenWidth, height: 100)
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MyPageNotificationCell.self, forCellWithReuseIdentifier: MyPageNotificationCell.reuseIdentifier)
        collectionView.bounces = false
        collectionView.delaysContentTouches = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    override func setupView() {
        setUpDelegate()
        view.backgroundColor = Constants.backgroundColor
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints({ m in
            m.edges.equalToSuperview()
        })
    }
    
    
    // MARK: - Functions
    private func setUpDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}


// MARK: - UICollectionViewDelegate
extension MyPageNotificationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.notifications.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageNotificationCell.reuseIdentifier, for: indexPath) as? MyPageNotificationCell else { return UICollectionViewCell() }
        cell.update(notification: viewModel.notifications[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        // 셀의 뷰 업데이트
        guard let cell = collectionView.cellForItem(at: indexPath) as? MyPageNotificationCell else { return }
        cell.didHighlight(notification: viewModel.notifications[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        // 셀의 뷰 업데이트
        guard let cell = collectionView.cellForItem(at: indexPath) as? MyPageNotificationCell else { return }
        cell.didUnHighlight(notification: viewModel.notifications[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 셀의 뷰 업데이트
        guard let cell = collectionView.cellForItem(at: indexPath) as? MyPageNotificationCell else { return }
        cell.didSelect(notification: viewModel.notifications[indexPath.row])
        
        if viewModel.notifications[indexPath.row].status == .UnRead {
            // 뷰모델 데이터 변경
            viewModel.notifications[indexPath.row].status = .Read
            
            // 알림 확인 API 요청
            viewModel.putNotificationReadStatus(notificationId: viewModel.notifications[indexPath.row].id)
        }
        
        // todo: 화면 이동
        switch viewModel.notifications[indexPath.row].type {
        case .Follow:
            print("follow")
        case .Comment:
            print("comment")
        case .Likes:
            print("likes")
        case .Register:
            print("register")
        case .Welcome:
            print("welcome")
        }
    }
}


// MARK: - UIScrollViewDelegate
extension MyPageNotificationViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if viewModel.notifications.isEmpty { return }
        
        guard let visibleCells = collectionView.visibleCells as? [MyPageNotificationCell] else { return }
        let ids = visibleCells.map{ $0.notificationId }
        
        if let lastId = viewModel.notifications.last?.id {
            let isFetched = viewModel.isFetched[lastId] ?? false
            if !isFetched && ids.contains(lastId) {
                viewModel.fetchNotifications(notificationId: lastId)
            }
        }
    }
}
