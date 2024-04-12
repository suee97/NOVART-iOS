//
//  HomeViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/06.
//

import UIKit
import Combine
import SnapKit

final class HomeViewController: BaseViewController, PullToRefreshProtocol {
    
    // MARK: - SnappingLayout
    
    private class SnappingUICollectionViewLayout: UICollectionViewCompositionalLayout {
                
        let topContentInset: CGFloat
        
        init(topContentInset: CGFloat , sectionProvider: @escaping UICollectionViewCompositionalLayoutSectionProvider) {
            self.topContentInset = topContentInset
            super.init(sectionProvider: sectionProvider)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
            guard let collectionView = collectionView else {
                return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
            }
            
            let parent = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
            
            let itemSpace = Constants.Feed.itemHeight + Constants.Feed.spacing
            var currentItemIdx = round(collectionView.contentOffset.y / itemSpace)
            
            if velocity.y > 0.5 {
                currentItemIdx += 1
            } else if velocity.y < -0.5 {
                currentItemIdx -= 1
            }
            
            let nearestPageOffset = currentItemIdx * itemSpace - topContentInset
            return CGPoint(x: parent.x, y: nearestPageOffset)
        }
    }
    
    // MARK: - Constants
    
    enum Constants {
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        static let leadingMargin: CGFloat = 24
        static let trailingMargin: CGFloat = 24
        
        enum Feed {
            static let itemWidth: CGFloat = screenWidth - leadingMargin * 2
            static let itemHeight: CGFloat = itemWidth * 4 / 3
            static let spacing: CGFloat = 24
        }
        
        enum FilterButton {
            static let leadingMargin: CGFloat = 28
            static let bottomMargin: CGFloat = 28
        }
        
        enum EmptyContentView {
            static let topMargin: CGFloat = 253
            static let iconWidth: CGFloat = 60
            static let iconHeight: CGFloat = 60
            
            static let text = "해당 카테고리의 작품이 없어요"
            static let font = UIFont.systemFont(ofSize: 16, weight: .regular)
            static let textColor = UIColor.Common.grey03
            static let textTopMargin: CGFloat = 16
        }
    }
    
    private func verticalContentInset() -> CGFloat {
        (view.safeAreaLayoutGuide.layoutFrame.height - Constants.Feed.itemHeight) / 4
    }
    
    // MARK: - UI
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.decelerationRate = .fast
        return collectionView
    }()
    
    private lazy var filterButton: FilterButton = {
        let button = FilterButton(filterTypes: CategoryType.allCases)
        button.delegate = self
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let emptyContentView: UIView = {
        let view = UIView()
        let imageView = UIImageView(image: UIImage(named: "icon_plain_warning"))
        view.addSubview(imageView)
        imageView.snp.makeConstraints({ m in
            m.centerX.top.equalToSuperview()
            m.width.equalTo(Constants.EmptyContentView.iconWidth)
            m.height.equalTo(Constants.EmptyContentView.iconHeight)
        })
        let label = UILabel()
        label.text = Constants.EmptyContentView.text
        label.font = Constants.EmptyContentView.font
        label.textColor = Constants.EmptyContentView.textColor
        view.addSubview(label)
        label.snp.makeConstraints({ m in
            m.centerX.equalToSuperview()
            m.top.equalTo(imageView.snp.bottom).offset(Constants.EmptyContentView.textTopMargin)
        })
        return view
    }()
    
    // MARK: - Properties
    
    private var viewModel: HomeViewModel
    private var dataSource: HomeDataSource
    var refreshControl: PlainRefreshControl
    private var subscriptions: Set<AnyCancellable> = .init()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.dataSource = HomeDataSource(collectionView: collectionView)
        self.refreshControl = PlainRefreshControl()
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadInitialData()
        setupRefreshControl()
    }
    
    // MARK: - Setup
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task { @MainActor in
            viewModel.showSetNicknameSceneIfNeeded()
        }
    }
    
    override func setupNavigationBar() {
        let logoImage = UIImage(named: "nav_logo_plain")
        let logoImageView = UIImageView(image: logoImage)
        self.navigationItem.titleView = logoImageView
    }
    
    override func setupView() {
        view.backgroundColor = .white
        
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
        collectionView.setCollectionViewLayout(homeCollectionViewLayout, animated: false)
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        view.addSubview(filterButton)
        NSLayoutConstraint.activate([
            filterButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.FilterButton.leadingMargin),
            filterButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.FilterButton.bottomMargin)
        ])
        
        view.addSubview(emptyContentView)
        emptyContentView.snp.makeConstraints({ m in
            m.centerX.equalToSuperview()
            m.top.equalTo(safeAreaLayoutGuide.snp.top).inset(Constants.EmptyContentView.topMargin)
        })
    }
    
    override func setupBindings() {
        viewModel.feedDataSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.dataSource.apply(items)
                self?.collectionView.isHidden = items.isEmpty
                self?.emptyContentView.isHidden = !items.isEmpty
            }
            .store(in: &subscriptions)
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

// MARK: - CollectionViewLayout
private extension HomeViewController {
    
    var feedSectionLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(Constants.Feed.itemWidth), heightDimension: .absolute(Constants.Feed.itemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(Constants.Feed.itemWidth), heightDimension: .absolute(Constants.Feed.itemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constants.Feed.spacing
        section.contentInsets = .init(top: 12, leading: Constants.leadingMargin, bottom: 0, trailing: Constants.trailingMargin)
        return section
    }
    
    var homeCollectionViewLayout: UICollectionViewLayout {
        let layout = SnappingUICollectionViewLayout(topContentInset: verticalContentInset()) { [weak self] (sectionIndex: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let self else { return nil }
            return self.feedSectionLayout
        }
        return layout
    }
}

// MARK: - CollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectProductAt(index: indexPath.row)
    }
}

// MARK: - ScrollViewDelegate
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + scrollView.bounds.height >= scrollView.contentSize.height) {
            viewModel.scrollViewDidReachBottom()
        }
    }
}

// MARK: - FilterButton
extension HomeViewController: FilterMenuViewDelegate {
    func didTapRowAt(menuView: FilterMenuView, category: CategoryType) {
        viewModel.selectedCategory = category
        viewModel.fetchFeedItems(category: category, lastId: nil)
    }
}
