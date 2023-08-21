//
//  DiscoverDataSource.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/16.
//

import UIKit

typealias DiscoverDataSourceType = UICollectionViewDiffableDataSource<DiscoverDataSource.Section, Int>
private typealias DiscoverDataSourceSnapshot = NSDiffableDataSourceSnapshot<DiscoverDataSource.Section, Int>

private typealias DiscoverProductCellRegistration = UICollectionView.CellRegistration<DiscoverProductCollectionViewCell, Int>

final class DiscoverDataSource: DiscoverDataSourceType {
    // MARK: - Section
    enum Section: Int, CaseIterable, Hashable {
        case product
    }
    
    // MARK: - Item
    enum Item: Hashable {
        case product
    }
    
    init(collectionView: UICollectionView, fetchItem: @escaping (Int) -> Int?) {

        let discoverProductCellRegistration = DiscoverProductCellRegistration { cell, _, itemIdentifier in
            guard let item = fetchItem(itemIdentifier) else { return }
            cell.update(with: item)
        }
        
        let sectionHeaderRegistration = UICollectionView.SupplementaryRegistration<ProductSortView>(elementKind: UICollectionView.elementKindSectionHeader) { _, _, _ in
        }
        
        super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in

            return collectionView.dequeueConfiguredReusableCell(using: discoverProductCellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        supplementaryViewProvider = { [weak collectionView] _, kind, indexPath in
            guard let collectionView else { return  nil }
            
            return collectionView.dequeueConfiguredReusableSupplementary(using: sectionHeaderRegistration, for: indexPath)
        }
    }
    
    func apply(_ items: [Int], for section: DiscoverDataSource.Section) {
        var snapshot = snapshot()
        snapshot.deleteSections([section])
        snapshot.appendSections([section])
        snapshot.appendItems(items, toSection: section)
        apply(snapshot, animatingDifferences: false)
    }

}
