//
//  SearchDataSource.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/09/24.
//

import UIKit

typealias SearchDataSourceType = UICollectionViewDiffableDataSource<SearchDataSource.Section, SearchProductModel>

private typealias SearchDataSourceSnapshot = NSDiffableDataSourceSnapshot<SearchDataSource.Section, SearchProductModel>
private typealias SearchProductCellRegistration = UICollectionView.CellRegistration<SearchProductCell, SearchProductModel>

final class SearchDataSource: SearchDataSourceType {

    // MARK: - Section
    enum Section: Int, CaseIterable, Hashable {
        case left
    }
    
    init(collectionView: UICollectionView) {
        
        let searchProductCellRegistration = SearchProductCellRegistration { cell, _, item in
            cell.update(with: item)
        }
        
        super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: searchProductCellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    func apply(_ items: [SearchProductModel]) {
        var snapshot = snapshot()
        
        snapshot.deleteSections([.left])
        snapshot.appendSections([.left])
        
        snapshot.appendItems(items, toSection: .left)
        apply(snapshot, animatingDifferences: false)
    }
}
