//
//  ArtistSearchViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/15.
//

import UIKit
import Combine
import SnapKit

final class ArtistSearchViewController: BaseViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let topMargin: CGFloat = 16
        static let bottomMargin: CGFloat = 24
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        static let leadingMargin: CGFloat = 24
        static let trailingMargin: CGFloat = 24
        static let horizontalInsets: CGFloat = 24
        static let itemSpacing: CGFloat = 12
        static let itemWidth: CGFloat = (screenWidth - horizontalInsets * 2 - itemSpacing) / 2
        static let itemHeight: CGFloat = itemWidth * 0.67
        
        enum NoResultView {
            static let width: CGFloat = 120
            static let topMargin: CGFloat = 24
        }
    }
    
    // MARK: - UI
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.contentInset = UIEdgeInsets(top: Constants.topMargin, left: 0, bottom: Constants.bottomMargin, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let noResultView = SearchNoResultView()
    
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
    }
    
    override func setupView() {
        view.addSubview(collectionView)
        view.addSubview(noResultView)
        
        collectionView.snp.makeConstraints({ m in
            m.edges.equalToSuperview()
        })
        
        noResultView.snp.makeConstraints({ m in
            m.width.equalTo(Constants.NoResultView.width)
            m.center.equalToSuperview()
            m.top.equalToSuperview().inset(Constants.NoResultView.topMargin)
        })
        
        collectionView.setCollectionViewLayout(searchCollectionViewLayout, animated: false)
        noResultView.isHidden = true
    }
    
    override func setupBindings() {
        viewModel.$artists
            .receive(on: DispatchQueue.main)
            .sink { items in
                self.dataSource.apply(items)
                if items.isEmpty {
                    self.noResultView.isHidden = false
                    self.collectionView.isHidden = true
                } else {
                    self.noResultView.isHidden = true
                    self.collectionView.isHidden = false
                }
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


// MARK: - ScrollViewDelegate
extension ArtistSearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + scrollView.bounds.height >= scrollView.contentSize.height) {
            viewModel.scrollViewDidReachBottom()
        }
    }
}
