//
//  DiscoverViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/06.
//

import UIKit
import Combine

class DiscoverViewController: BaseViewController {

    // MARK: - Constants
    
    enum Constants {
        static let leadingMargin: CGFloat = 24
        static let trailingMargin: CGFloat = 24
        
        enum CategoryView {
            static let height: CGFloat = 54
        }
        
        enum ProductSortView {
            static let height: CGFloat = 48
        }
        
        enum ProductLayout {
            static var itemWidth: CGFloat {
                let screenWidth = UIScreen.main.bounds.width
                return (screenWidth - 62) / 2
            }
            
            static var itemHeight: CGFloat {
                itemWidth + 74
            }
            
            static let horizontalSpacing: CGFloat = 14
            static let verticalSpacing: CGFloat = 40
        }
    }
    
    // MARK: - UI
    
    private lazy var categoryView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
    
        let categories = ["전체", "그림", "가구", "조명", "공예"]
        var buttons: [UIView] = []
        
        categories.forEach {
            let button = CategoryButton()
            button.text = $0
            buttons.append(button)
        }

        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.spacing = 4

        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let dividerView = UIView()
        dividerView.backgroundColor = UIColor.Common.grey01
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        view.addSubview(dividerView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leadingMargin),
            dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Properties
    
    private var viewModel: DiscoverViewModel
    private var dataSource: DiscoverDataSource
    
    private var subscriptions: Set<AnyCancellable> = .init()
    
    init(viewModel: DiscoverViewModel) {
        self.viewModel = viewModel
        self.dataSource = DiscoverDataSource(collectionView: collectionView, fetchItem: viewModel.fetchItem)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchData()
    }
    
    override func setupNavigationBar() {
        
        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 24, height: 24))

        let searchButton = UIButton(frame: iconSize)
        searchButton.setBackgroundImage(UIImage(named: "icon_search"), for: .normal)
        let searchItem = UIBarButtonItem(customView: searchButton)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 16
        
        let notificationButton = UIButton(frame: iconSize)
        notificationButton.setBackgroundImage(UIImage(named: "icon_notification"), for: .normal)
        let notificationItem = UIBarButtonItem(customView: notificationButton)
        
        self.navigationItem.rightBarButtonItems = [searchItem, spacer, notificationItem]
    }
    
    override func setupView() {
        view.backgroundColor = UIColor.white
        
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        
        view.addSubview(categoryView)
        NSLayoutConstraint.activate([
            categoryView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            categoryView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            categoryView.heightAnchor.constraint(equalToConstant: Constants.CategoryView.height)
        ])
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: categoryView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
        collectionView.setCollectionViewLayout(discoverCollectionViewLayout, animated: false)
    }
    
    override func setupBindings() {
        viewModel.productDataSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.dataSource.apply(data, for: .product)
            }
            .store(in: &subscriptions)
    }
}

// MARK: - CollectionViewLayout
private extension DiscoverViewController {
    
    var sectionHeader: NSCollectionLayoutBoundarySupplementaryItem {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(Constants.ProductSortView.height))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: size, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return header
    }
    
    var productLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(Constants.ProductLayout.itemWidth), heightDimension: .absolute(Constants.ProductLayout.itemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(Constants.ProductLayout.itemWidth * 2 + Constants.ProductLayout.horizontalSpacing), heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(Constants.ProductLayout.horizontalSpacing)
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constants.ProductLayout.verticalSpacing
        section.contentInsets = .init(top: 0, leading: Constants.leadingMargin, bottom: 0, trailing: Constants.trailingMargin)
        
        let header = sectionHeader
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    var discoverCollectionViewLayout: UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let self else { return nil }
            return self.productLayout
        }
        return layout
    }
}
