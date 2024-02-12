//
//  HomeViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/06.
//

import UIKit
import Combine

class HomeViewController: BaseViewController {
    
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
    
    private lazy var devInfoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.setTitle("호출", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.tempInfoCall()
        }), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    private var viewModel: HomeViewModel
    private var dataSource: HomeDataSource
    
    private var subscriptions: Set<AnyCancellable> = .init()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.dataSource = HomeDataSource(collectionView: collectionView)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadInitialData()
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
        
        view.addSubview(devInfoButton)
        NSLayoutConstraint.activate([
            devInfoButton.widthAnchor.constraint(equalToConstant: 50),
            devInfoButton.heightAnchor.constraint(equalToConstant: 50),
            devInfoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            devInfoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        ])
    }
    
    override func setupBindings() {
        viewModel.feedDataSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.dataSource.apply(items)
            }
            .store(in: &subscriptions)
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

// MARK: - FilterButton
extension HomeViewController: FilterMenuViewDelegate {
    func didTapRowAt(menuView: FilterMenuView, category: CategoryType) {
        viewModel.selectedCategory = category
        viewModel.fetchFeedItems(category: category, lastId: nil)
    }
}
