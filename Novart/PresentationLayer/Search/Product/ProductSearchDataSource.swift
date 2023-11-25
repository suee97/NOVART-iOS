//
//  ProductSearchDataSource.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/09/24.
//

import UIKit

typealias ProductSearchDataSourceType = UICollectionViewDiffableDataSource<ProductSearchDataSource.Section, SearchProductModel>

private typealias ProductSearchDataSourceSnapshot = NSDiffableDataSourceSnapshot<ProductSearchDataSource.Section, SearchProductModel>
private typealias ProductSearchProductCellRegistration = UICollectionView.CellRegistration<SearchProductCell, SearchProductModel>

final class ProductSearchDataSource: ProductSearchDataSourceType {

    // MARK: - Section
    enum Section: Int, CaseIterable, Hashable {
        case product
    }
    
    init(collectionView: UICollectionView) {
        
        let searchProductCellRegistration = ProductSearchProductCellRegistration { cell, _, item in
            cell.update(with: item)
        }
        
        super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: searchProductCellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    func apply(_ items: [SearchProductModel]) {
        var snapshot = snapshot()
        
        snapshot.deleteSections([.product])
        snapshot.appendSections([.product])
        
        snapshot.appendItems(items, toSection: .product)
        apply(snapshot, animatingDifferences: false)
    }
}
