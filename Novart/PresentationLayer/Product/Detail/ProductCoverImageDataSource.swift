//
//  ProductCoverImageDataSource.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/07.
//

import UIKit

typealias ProductCoverImageDataSourceType = UICollectionViewDiffableDataSource<ProductCoverImageDataSource.Section, String>

private typealias ProductCoverImageDataSourceSnapshot = NSDiffableDataSourceSnapshot<ProductCoverImageDataSource.Section, String>
private typealias ProductCoverImageCellRegistration = UICollectionView.CellRegistration<ProductCoverCell, String>

final class ProductCoverImageDataSource: ProductCoverImageDataSourceType {

    // MARK: - Section
    enum Section: Int, CaseIterable, Hashable {
        case cover
    }
    
    init(collectionView: UICollectionView) {
        let productCoverImageCellRegistration = ProductCoverImageCellRegistration { cell, _, item in
            cell.update(with: item)
        }
        
        super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: productCoverImageCellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    func apply(_ items: [String]) {
        var snapshot = snapshot()
        
        snapshot.deleteSections([.cover])
        snapshot.appendSections([.cover])
        
        snapshot.appendItems(items, toSection: .cover)
        apply(snapshot, animatingDifferences: false)
    }
}

