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
            static let leftMargin: CGFloat = 8
            static let rightMargin: CGFloat = 8
            static let topInset: CGFloat = 16
            
            static let cellWidth: CGFloat = Constants.screenWidth - 16
            static let cellSpacing: CGFloat = 24
            static let defaultCellHeight: CGFloat = 58 // notificationLabel을 고려하지 않은 Cell 높이
            
            static let notificationLabelWidth: CGFloat = Constants.screenWidth - 108
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
            self.collectionView.reloadData()
        }).store(in: &cancellables)
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
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MyPageNotificationCell.self, forCellWithReuseIdentifier: MyPageNotificationCell.reuseIdentifier)
        collectionView.bounces = false
        collectionView.delaysContentTouches = false
        collectionView.contentInset = UIEdgeInsets(top: Constants.CollectionView.topInset, left: 0, bottom: 0, right: 0)
        return collectionView
    }()
    
    override func setupView() {
        viewModel.fetchNotifications()
        setUpDelegate()
        view.backgroundColor = Constants.backgroundColor
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints({ m in
            m.left.equalToSuperview().inset(Constants.CollectionView.leftMargin)
            m.right.equalToSuperview().inset(Constants.CollectionView.rightMargin)
            m.top.bottom.equalToSuperview()
        })
    }
    
    
    // MARK: - Functions
    private func setUpDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func getLabelHeight(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let textForGetSize: String = viewModel.notifications[indexPath.row].body
        let labelHeight = getLabelHeight(text: textForGetSize, font: UIFont.systemFont(ofSize: 16, weight: .medium), width: Constants.CollectionView.notificationLabelWidth)
        return CGSize(width: collectionView.frame.width, height: Constants.CollectionView.defaultCellHeight + labelHeight)
    }
}

