//
//  HomeViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/06.
//

import UIKit
import Combine

class HomeViewController: BaseViewController {

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
    
    // MARK: - UI
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var filterButton: FilterButton = {
        let button = FilterButton()
        button.translatesAutoresizingMaskIntoConstraints = false
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
        viewModel.fetchData()
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
        
        view.addSubview(filterButton)
        NSLayoutConstraint.activate([
            filterButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.FilterButton.leadingMargin),
            filterButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.FilterButton.bottomMargin)
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
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let self else { return nil }
            return self.feedSectionLayout
        }
        return layout
    }
}
