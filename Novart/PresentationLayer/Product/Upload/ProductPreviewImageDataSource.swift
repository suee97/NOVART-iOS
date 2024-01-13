//
//  ProductPreviewImageDataSource.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/31.
//

import UIKit

typealias ProductPreviewImageDataSourceType = UICollectionViewDiffableDataSource<ProductPreviewImageDataSource.Section, UIImage>

private typealias ProductPreviewImageDataSourceSnapshot = NSDiffableDataSourceSnapshot<ProductPreviewImageDataSource.Section, UIImage>
private typealias ProductPreviewImageCellRegistration = UICollectionView.CellRegistration<ProductCoverCell, UIImage>

final class ProductPreviewImageDataSource: ProductPreviewImageDataSourceType {

    // MARK: - Section
    enum Section: Int, CaseIterable, Hashable {
        case cover
    }
    
    init(collectionView: UICollectionView) {
        let productCoverImageCellRegistration = ProductPreviewImageCellRegistration { cell, _, item in
            cell.update(image: item)
        }
        
        super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: productCoverImageCellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    func apply(_ items: [UIImage]) {
        var snapshot = snapshot()
        
        snapshot.deleteSections([.cover])
        snapshot.appendSections([.cover])
        
        snapshot.appendItems(items, toSection: .cover)
        apply(snapshot, animatingDifferences: false)
    }
}

