//
//  RecentSearchView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/15.
//

import UIKit
import Combine

protocol RecentSearchViewDelegate: AnyObject {
    func didTapCell(at index: Int)
}

final class RecentSearchView: UIView {
    
    // MARK: - Constants
    
    enum Constants {
        
        static let horizontalInsets: CGFloat = 24
        static let topMargin: CGFloat = 8
        
        enum Recent {
            static let titleFont: UIFont = .systemFont(ofSize: 16, weight: .bold)
            static let titleColor: UIColor = UIColor.Common.black
            static let bottomMargin: CGFloat = 12
        }
        
        enum Delete {
            static let buttonFont: UIFont = .systemFont(ofSize: 14, weight: .regular)
            static let buttonColor: UIColor = UIColor.Common.grey03
        }
        
        enum Cell {
            static let height: CGFloat = 42
            static let spacing: CGFloat = 8
        }
    }
    
    // MARK: - UI
    
    private lazy var recentTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Recent.titleFont
        label.textColor = Constants.Recent.titleColor
        label.text = "최근 검색"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("모두 삭제", for: .normal)
        button.setTitleColor(Constants.Delete.buttonColor, for: .normal)
        button.titleLabel?.font = Constants.Delete.buttonFont
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.deleteAllRecent()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RecentSearchCell.self, forCellWithReuseIdentifier: RecentSearchCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var viewModel: SearchViewModel
    private var cancellables: Set<AnyCancellable> = .init()
    weak var delegate: RecentSearchViewDelegate?
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBindings() {
        viewModel.$recentSearch
            .receive(on: DispatchQueue.main)
            .sink { [weak self] recent in
                guard let self else { return }
                self.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupView() {
        backgroundColor = UIColor.white
        addSubview(recentTitleLabel)
        NSLayoutConstraint.activate([
            recentTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.topMargin),
            recentTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.horizontalInsets)
        ])
        
        addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.horizontalInsets),
            deleteButton.centerYAnchor.constraint(equalTo: recentTitleLabel.centerYAnchor)
        ])
        
        collectionView.setCollectionViewLayout(collectionViewLayout, animated: false)
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: Constants.Cell.height),
            collectionView.topAnchor.constraint(equalTo: recentTitleLabel.bottomAnchor, constant: Constants.Recent.bottomMargin),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
    }
}

extension RecentSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.recentSearch.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCell.reuseIdentifier, for: indexPath) as? RecentSearchCell else {
            return UICollectionViewCell()
        }
        
        let title = viewModel.recentSearch[indexPath.row]
        cell.update(text: title)
        cell.didTapDelete = { [weak self] in
            self?.viewModel.deleteRecent(query: title)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapCell(at: indexPath.row)
    }
    
}

extension RecentSearchView {
    var sectionLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(1.0), heightDimension: .absolute(Constants.Cell.height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(1.0), heightDimension: .absolute(Constants.Cell.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = Constants.Cell.spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: Constants.horizontalInsets, bottom: 0, trailing: Constants.horizontalInsets)
        return section
    }
    
    var collectionViewLayout: UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let self else { return nil }
            return self.sectionLayout
        }
        return layout
    }
}
