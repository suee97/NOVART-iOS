//
//  ArtistSearchViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/15.
//

import UIKit
import Combine

final class ArtistSearchViewController: BaseViewController {
    
    // MARK: - Constants
    
    enum Constants {
        static let topMargin: CGFloat = 16
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        static let leadingMargin: CGFloat = 24
        static let trailingMargin: CGFloat = 24
        static let horizontalInsets: CGFloat = 24
        static let itemSpacing: CGFloat = 12
        static let itemWidth: CGFloat = (screenWidth - horizontalInsets * 2 - itemSpacing) / 2
        static let itemHeight: CGFloat = itemWidth * 0.67
    }
    
    // MARK: - UI

    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.contentInset = UIEdgeInsets(top: Constants.topMargin, left: 0, bottom: 0, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    private var viewModel: ArtistSearchViewModel
    private var dataSource: ArtistSearchDataSource
    
    private var subscriptions: Set<AnyCancellable> = .init()
    
    // MARK: - Initialization

    init(viewModel: ArtistSearchViewModel) {
        self.viewModel = viewModel
        self.dataSource = ArtistSearchDataSource(collectionView: collectionView)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData()
    }
    
    override func setupView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        collectionView.setCollectionViewLayout(searchCollectionViewLayout, animated: false)
        
    }
    
    override func setupBindings() {
        viewModel.searchResultSubject
            .receive(on: DispatchQueue.main)
            .sink { items in
                self.dataSource.apply(items)
            }
            .store(in: &subscriptions)
    }
}

// MARK: - CollectionViewLayout
private extension ArtistSearchViewController {
    
    func verticalSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(Constants.itemWidth), heightDimension: .absolute(Constants.itemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(Constants.itemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(Constants.itemSpacing)


        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constants.itemSpacing
        section.contentInsets = .init(top: 0, leading: Constants.horizontalInsets, bottom: 0, trailing: Constants.horizontalInsets)
        return section
    }
    
    var leftSection: NSCollectionLayoutSection {
        verticalSectionLayout()
    }
    
    var rightSection: NSCollectionLayoutSection {
        verticalSectionLayout()
    }
    
    var searchCollectionViewLayout: UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            return self?.verticalSectionLayout()
        }
        return layout
    }
}
