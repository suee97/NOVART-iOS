//
//  SearchViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/06.
//

import UIKit
import Combine

class SearchViewController: BaseViewController {

    // MARK: - Constants
    
    enum Constants {
        
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        static let leadingMargin: CGFloat = 24
        static let trailingMargin: CGFloat = 24
        static let horizontalInsets: CGFloat = 24
        static let itemSpacing: CGFloat = 12
        
        static let itemWidth: CGFloat = (screenWidth - SearchViewController.Constants.horizontalInsets * 2 - SearchViewController.Constants.itemSpacing) / 2
        static let itemHeight: CGFloat = itemWidth * 1.34
        
        enum SearchBar {
            static let placeholderText: String = "검색"
            static let horizontalMargin: CGFloat = 16
        }
        
        enum CategoryTab {
            static let spacing: CGFloat = 8
            static let height: CGFloat = 38
        }
        
        enum Product {
            static let itemWidth: CGFloat = (screenWidth - horizontalInsets * 2 - itemSpacing) / 2
            static let itemHeight: CGFloat = itemWidth * 1.34
            
        }
    }
    
    // MARK: - UI

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = Constants.SearchBar.placeholderText
        searchBar.backgroundImage = UIImage()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private lazy var categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = Constants.CategoryTab.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var categoryScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(categoryStackView)
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: Constants.leadingMargin, bottom: 0, right: 0)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Properties
    
    private var viewModel: SearchViewModel
    private var dataSource: SearchDataSource
    
    private var subscriptions: Set<AnyCancellable> = .init()

    // MARK: - Initialization

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        self.dataSource = SearchDataSource(collectionView: collectionView)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData()
        view.backgroundColor = .white
    }
    
    // MARK: - Setup

    override func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func setupView() {
        
        let safeArea = view.safeAreaLayoutGuide

        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeArea.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constants.SearchBar.horizontalMargin),
            searchBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Constants.SearchBar.horizontalMargin)
        ])
        
        viewModel.categoryItems.forEach { type in
            let categoryButton = CategoryTabButton()
            categoryButton.text = type.rawValue
            if type == .all {
                categoryButton.isSelected = true
            }
            
            categoryButton.action = { [weak self] isSelected in
                guard let self else { return }
                if isSelected {
                    self.viewModel.didTapCategory(type: type)
                }
            }
            categoryStackView.addArrangedSubview(categoryButton)
        }
        
        view.addSubview(categoryScrollView)
        NSLayoutConstraint.activate([
            categoryScrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            categoryScrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            categoryScrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            categoryScrollView.heightAnchor.constraint(equalToConstant: Constants.CategoryTab.height),
            
            categoryStackView.leadingAnchor.constraint(equalTo: categoryScrollView.leadingAnchor),
            categoryStackView.trailingAnchor.constraint(equalTo: categoryScrollView.trailingAnchor),
            categoryStackView.topAnchor.constraint(equalTo: categoryScrollView.topAnchor),
            categoryStackView.bottomAnchor.constraint(equalTo: categoryScrollView.bottomAnchor),
            categoryStackView.heightAnchor.constraint(equalTo: categoryScrollView.heightAnchor)
        ])
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: categoryScrollView.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
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

extension SearchViewController: UISearchBarDelegate {
    
}

// MARK: - CollectionViewLayout
private extension SearchViewController {
    
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
