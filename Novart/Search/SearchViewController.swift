//
//  SearchViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/06.
//

import UIKit

class SearchViewController: BaseViewController {

    // MARK: - Constants
    
    private enum Constants {
        
        static let leadingMargin: CGFloat = 24
        
        enum SearchBar {
            static let placeholderText: String = "검색"
            static let horizontalMargin: CGFloat = 16
        }
        
        enum CategoryTab {
            static let spacing: CGFloat = 8
            static let height: CGFloat = 38
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
    
    // MARK: - Properties
    
    private var viewModel: SearchViewModel
    
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
    }
}

extension SearchViewController: UISearchBarDelegate {
    
}
