import UIKit
import SnapKit
import Combine

final class MyPageNotificationViewController: BaseViewController, PullToRefreshProtocol {
    
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
        
        enum EmptyView {
            static let iconDiameter: CGFloat = 24
            static let text = "받은 알림이 없어요"
            static let textColor = UIColor.Common.grey03
            static let font = UIFont.systemFont(ofSize: 16, weight: .regular)
            static let textTopMargin: CGFloat = 8
        }
    }
    
    
    // MARK: - Properties
    private var viewModel: MyPageNotificationViewModel
    private var cancellables = Set<AnyCancellable>()
    var refreshControl: PlainRefreshControl
    
    
    // MARK: - LifeCycle
    init(viewModel: MyPageNotificationViewModel) {
        self.viewModel = viewModel
        self.refreshControl = PlainRefreshControl()
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupBindings() {
        viewModel.$notifications
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { notifications in
                if notifications.isEmpty {
                    self.collectionView.isHidden = true
                    self.emptyView.isHidden = false
                } else {
                    self.collectionView.isHidden = false
                    self.emptyView.isHidden = true
                }
                self.collectionView.reloadData()
            }).store(in: &cancellables)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchNotifications(notificationId: 0)
        setupRefreshControl()
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
        collectionView.delaysContentTouches = false
        return collectionView
    }()
    
    override func setupView() {
        setUpDelegate()
        view.backgroundColor = Constants.backgroundColor
        
        view.addSubview(collectionView)
        view.addSubview(emptyView)
        
        collectionView.snp.makeConstraints({ m in
            m.edges.equalToSuperview()
        })
        emptyView.snp.makeConstraints({ m in
            m.center.equalToSuperview()
        })
    }
    
    private let emptyView: UIView = {
        let view = UIView()
        let imageView = UIImageView(image: UIImage(named: "icon_notification_stroke"))
        let label = UILabel()
        label.text = Constants.EmptyView.text
        label.textColor = Constants.EmptyView.textColor
        label.font = Constants.EmptyView.font
        label.sizeToFit()
        
        view.addSubview(imageView)
        view.addSubview(label)
        imageView.snp.makeConstraints({ m in
            m.width.height.equalTo(Constants.EmptyView.iconDiameter)
            m.centerX.top.equalToSuperview()
        })
        label.snp.makeConstraints({ m in
            m.centerX.equalToSuperview()
            m.top.equalTo(imageView.snp.bottom).offset(Constants.EmptyView.textTopMargin)
        })
        
        return view
    }()
    
    
    // MARK: - Functions
    private func setUpDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setupRefreshControl() {
        collectionView.refreshControl = refreshControl
        collectionView.refreshControl?.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
    }
    
    @objc func onRefresh() {
        Task {
            await viewModel.onRefresh()
            await MainActor.run {
                self.collectionView.refreshControl?.endRefreshing()
            }
        }
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
        
        viewModel.didTapNotification(at: indexPath)
    }
}


// MARK: - UIScrollViewDelegate
extension MyPageNotificationViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let visibleCells = collectionView.visibleCells as? [MyPageNotificationCell] else { return }
        let cellIds = visibleCells.compactMap{$0.notificationId}
        viewModel.scrollViewDidReachBottom(cellIds: cellIds)
    }
}
