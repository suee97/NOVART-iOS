//
//  HomeDataSource.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/12.
//

import UIKit

typealias HomeDataSourceType = UICollectionViewDiffableDataSource<HomeDataSource.Section, HomeProductItemViewModel>

private typealias HomeDataSourceSnapshot = NSDiffableDataSourceSnapshot<HomeDataSource.Section, HomeProductItemViewModel>
private typealias HomeFeedCellRegistration = UICollectionView.CellRegistration<HomeProductCell, HomeProductItemViewModel>

final class HomeDataSource: HomeDataSourceType {

    // MARK: - Section
    enum Section: Int, CaseIterable, Hashable {
        case feed
    }
    
    init(collectionView: UICollectionView, delegate: HomeProductCellDelegate) {
        let homeFeedCellRegistration = HomeFeedCellRegistration { cell, _, item in
            cell.update(with: item, delegate: delegate)
        }
        
        super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: homeFeedCellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    func apply(_ items: [HomeProductItemViewModel]) {
        var snapshot = snapshot()
        
        snapshot.deleteSections([.feed])
        snapshot.appendSections([.feed])
        
        snapshot.appendItems(items, toSection: .feed)
        apply(snapshot, animatingDifferences: false)
    }
}
