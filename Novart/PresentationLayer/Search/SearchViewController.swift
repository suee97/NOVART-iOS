//
//  SearchViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/06.
//

import UIKit
import Combine
import SnapKit

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
            static let buttonFont: UIFont = .systemFont(ofSize: 16, weight: .regular)
            static let buttonColor: UIColor = UIColor.Common.black
            static let trailingMargin: CGFloat = 6
        }
        
        enum CategoryTab {
            static let spacing: CGFloat = 8
            static let height: CGFloat = 38
        }
        
        enum PageTab {
            static let topMargin: CGFloat = 14
            static let selectedFont: UIFont = .systemFont(ofSize: 16, weight: .bold)
            static let font: UIFont = .systemFont(ofSize: 16, weight: .medium)
            static let tintColor: UIColor = UIColor.Common.grey04
            static let textColor: UIColor = UIColor.Common.grey02
            static let buttonWidth: CGFloat = (screenWidth - horizontalInsets * 2) / 2
            static let buttonHeight: CGFloat = 24
            static let indicatorHeight: CGFloat = 2
        }
        
        enum Divider {
            static let height: CGFloat = 1
            static let color: UIColor = UIColor.Common.grey01
            static let topMargin: CGFloat = 9
        }
        
        enum Product {
            static let itemWidth: CGFloat = (screenWidth - horizontalInsets * 2 - itemSpacing) / 2
            static let itemHeight: CGFloat = itemWidth * 1.34
        }
        
        enum OrangeCircle {
            static let diameter: CGFloat = 4
            static let color = UIColor.init(hexString: "#FF7337")
            static let leftMargin: CGFloat = 2
            static let topMargin: CGFloat = 4
            static let centerDistanceFromButtonLabel: CGFloat = 6
        }
    }
    
    // MARK: - UI
    final class OrangeCircle: UIView {
        init() {
            super.init(frame: .zero)
            backgroundColor = Constants.OrangeCircle.color
            self.snp.makeConstraints({ m in
                m.width.height.equalTo(Constants.OrangeCircle.diameter)
            })
            layer.cornerRadius = Constants.OrangeCircle.diameter / 2
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = Constants.SearchBar.placeholderText
        searchBar.backgroundImage = UIImage()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private lazy var cancelSearchButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(Constants.SearchBar.buttonColor, for: .normal)
        button.titleLabel?.font = Constants.SearchBar.buttonFont
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.searchBar.text = ""
            self.searchBar.endEditing(true)
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchBarStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchBar, cancelSearchButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = Constants.SearchBar.trailingMargin
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
    
    private let productOrangeCircle = OrangeCircle()
    private let artistOrangeCircle = OrangeCircle()
    
    private lazy var productButton: UIButton = {
        let button = UIButton()
        button.setTitle("작품", for: .normal)
        button.setTitleColor(Constants.PageTab.textColor, for: .normal)
        button.setTitleColor(Constants.PageTab.tintColor, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: Constants.PageTab.buttonWidth),
            button.heightAnchor.constraint(equalToConstant: Constants.PageTab.buttonHeight)
        ])
        if let titleLabel = button.titleLabel {
            button.addSubview(productOrangeCircle)
            productOrangeCircle.snp.makeConstraints({ m in
                m.left.equalTo(titleLabel.snp.right).offset(Constants.OrangeCircle.leftMargin)
                m.centerY.equalTo(titleLabel.snp.centerY).offset(-Constants.OrangeCircle.centerDistanceFromButtonLabel)
            })
        }
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            if self.currentViewController == self.artistSearchViewController {
                self.pageViewController.setViewControllers([self.productSearchViewController], direction: .reverse, animated: true)  { completed in
                    if completed {
                        self.currentViewController = self.productSearchViewController
                    }
                }
            }
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var artistButton: UIButton = {
        let button = UIButton()
        button.setTitle("작가", for: .normal)
        button.titleLabel?.font = Constants.PageTab.font
        button.setTitleColor(Constants.PageTab.textColor, for: .normal)
        button.setTitleColor(Constants.PageTab.tintColor, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: Constants.PageTab.buttonWidth),
            button.heightAnchor.constraint(equalToConstant: Constants.PageTab.buttonHeight)
        ])
        if let titleLabel = button.titleLabel {
            button.addSubview(artistOrangeCircle)
            artistOrangeCircle.snp.makeConstraints({ m in
                m.left.equalTo(titleLabel.snp.right).offset(Constants.OrangeCircle.leftMargin)
                m.centerY.equalTo(titleLabel.snp.centerY).offset(-Constants.OrangeCircle.centerDistanceFromButtonLabel)
            })
        }
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            if self.currentViewController == self.productSearchViewController {
                self.pageViewController.setViewControllers([self.artistSearchViewController], direction: .forward, animated: true) { completed in
                    if completed {
                        self.currentViewController = self.artistSearchViewController
                    }
                }
            }
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var pageTabStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productButton, artistButton])
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var navigationBarDividerView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Divider.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var pageIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.PageTab.tintColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        for view in pageViewController.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.delegate = self
            }
        }
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        return pageViewController
    }()
    
    private lazy var productSearchViewController: ProductSearchViewController = {
        let viewController = ProductSearchViewController(viewModel: viewModel.productViewModel)
        return viewController
    }()
    
    private lazy var artistSearchViewController: ArtistSearchViewController = {
        let viewController = ArtistSearchViewController(viewModel: viewModel.artistViewModel)
        return viewController
    }()
    
    private lazy var recentSearchView: RecentSearchView = {
        let view = RecentSearchView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Properties
    
    private var viewModel: SearchViewModel
    
    private var subscriptions: Set<AnyCancellable> = .init()

    private var transitionProgress: CGFloat = 0.0 {
        didSet {
            leadingConstraint?.constant = Constants.PageTab.buttonWidth * transitionProgress
            view.layoutIfNeeded()
        }
    }
    private var leadingConstraint: NSLayoutConstraint?
    private var currentViewController: UIViewController? {
        didSet {
            updateSelectedPage()
        }
    }

    // MARK: - Initialization

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadIntialData()
    }
    
    // MARK: - Setup
    override func setupBindings() {
        viewModel.$searchResult.sink(receiveValue: { data in
            guard let data else { return }
            DispatchQueue.main.async {
                self.productOrangeCircle.isHidden = data.products.isEmpty
                self.artistOrangeCircle.isHidden = data.artists.isEmpty
            }
        }).store(in: &subscriptions)
    }

    override func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func setupView() {
        view.backgroundColor = .white
        
        let safeArea = view.safeAreaLayoutGuide
        
        cancelSearchButton.isHidden = true
        view.addSubview(searchBarStackView)
        NSLayoutConstraint.activate([
            searchBarStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            searchBarStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constants.SearchBar.horizontalMargin),
            searchBarStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Constants.SearchBar.horizontalMargin)
        ])
        
        searchBar.text = viewModel.searchResult?.query
        
        viewModel.categoryItems.forEach { type in
            let categoryButton = CategoryTabButton()
            categoryButton.text = type.rawValue
            if type == .all {
                categoryButton.isSelected = true
            }
            
            categoryButton.action = { [weak self] isSelected in
                guard let self else { return }
                for button in self.categoryStackView.arrangedSubviews {
                    if let button = button as? CategoryTabButton, button.text != type.rawValue {
                        button.isSelected = false
                    }
                }
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
            categoryScrollView.topAnchor.constraint(equalTo: searchBarStackView.bottomAnchor),
            categoryScrollView.heightAnchor.constraint(equalToConstant: Constants.CategoryTab.height),
            
            categoryStackView.leadingAnchor.constraint(equalTo: categoryScrollView.leadingAnchor),
            categoryStackView.trailingAnchor.constraint(equalTo: categoryScrollView.trailingAnchor),
            categoryStackView.topAnchor.constraint(equalTo: categoryScrollView.topAnchor),
            categoryStackView.bottomAnchor.constraint(equalTo: categoryScrollView.bottomAnchor),
            categoryStackView.heightAnchor.constraint(equalTo: categoryScrollView.heightAnchor)
        ])
        
        view.addSubview(pageTabStackView)
        NSLayoutConstraint.activate([
            pageTabStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            pageTabStackView.topAnchor.constraint(equalTo: categoryScrollView.bottomAnchor, constant: Constants.PageTab.topMargin)
        ])
        
        view.addSubview(navigationBarDividerView)
        NSLayoutConstraint.activate([
            navigationBarDividerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            navigationBarDividerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            navigationBarDividerView.topAnchor.constraint(equalTo: pageTabStackView.bottomAnchor, constant: Constants.Divider.topMargin),
            navigationBarDividerView.heightAnchor.constraint(equalToConstant: Constants.Divider.height)
        ])
        
        view.addSubview(pageViewController.view)
        NSLayoutConstraint.activate([
            pageViewController.view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            pageViewController.view.topAnchor.constraint(equalTo: navigationBarDividerView.bottomAnchor)
                                                            
        ])
        
        pageViewController.setViewControllers([productSearchViewController], direction: .forward, animated: true)
        currentViewController = productSearchViewController
        
        view.addSubview(pageIndicatorView)
        leadingConstraint = pageIndicatorView.leadingAnchor.constraint(equalTo: pageTabStackView.leadingAnchor)
        leadingConstraint?.isActive = true
        NSLayoutConstraint.activate([
            pageIndicatorView.bottomAnchor.constraint(equalTo: navigationBarDividerView.bottomAnchor),
            pageIndicatorView.heightAnchor.constraint(equalToConstant: Constants.PageTab.indicatorHeight),
            pageIndicatorView.widthAnchor.constraint(equalToConstant: Constants.PageTab.buttonWidth),
        ])
        
        view.addSubview(recentSearchView)
        NSLayoutConstraint.activate([
            recentSearchView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            recentSearchView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            recentSearchView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            recentSearchView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        recentSearchView.isHidden = true
    }
    
    private func updateSelectedPage() {
        if currentViewController == productSearchViewController {
            transitionProgress = 0.0
            artistButton.isSelected = false
            productButton.isSelected = true
            productButton.titleLabel?.font = Constants.PageTab.selectedFont
            artistButton.titleLabel?.font = Constants.PageTab.font
        } else if currentViewController == artistSearchViewController {
            transitionProgress = 1.0
            artistButton.isSelected = true
            productButton.isSelected = false
            artistButton.titleLabel?.font = Constants.PageTab.selectedFont
            productButton.titleLabel?.font = Constants.PageTab.font
        }
    }
}


// MARK: - SearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchQuery = searchBar.text else { return }
        viewModel.performSearch(query: searchQuery)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        recentSearchView.isHidden = false
        cancelSearchButton.isHidden = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        recentSearchView.isHidden = true
        cancelSearchButton.isHidden = true
    }
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

extension SearchViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController == artistSearchViewController {
            return productSearchViewController
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController == productSearchViewController {
            return artistSearchViewController
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let currentViewController = pageViewController.viewControllers?.first else { return }
        self.currentViewController = currentViewController
    }
}

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let xOffset = scrollView.contentOffset.x
        let progress = xOffset / pageWidth
                
        if currentViewController == productSearchViewController {
            if progress > 1.0 && progress <= 2.0 {
                transitionProgress = progress - 1.0
            }
        } else if currentViewController == artistSearchViewController {
            if progress >= 0.0 && progress < 1.0 {
                transitionProgress = progress
            }
        }
    }
}
