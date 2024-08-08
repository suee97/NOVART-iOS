//
//  HomeProductImageDataSource.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/08/19.
//

import UIKit

typealias HomeProductImageDataSourceType = UICollectionViewDiffableDataSource<HomeProductImageDataSource.Section, Int>

private typealias HomeProductImageDataSourceSnapshot = NSDiffableDataSourceSnapshot<HomeDataSource.Section, Int>
private typealias HomeProductImageCellRegistration = UICollectionView.CellRegistration<HomeProductImageCell, Int>

final class HomeProductImageDataSource: HomeProductImageDataSourceType {

    // MARK: - Section
    enum Section: Int, CaseIterable, Hashable {
        case image
    }
    
    init(collectionView: UICollectionView, dataProvider: @escaping ((Int) -> String)) {
        let feedImageCellRegistration = HomeProductImageCellRegistration { cell, _, item in
            let imageUrl = dataProvider(item)
            cell.update(with: imageUrl)
        }
        
        super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: feedImageCellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    func apply(_ items: [Int]) {
        var snapshot = snapshot()
        
        snapshot.deleteSections([.image])
        snapshot.appendSections([.image])
        
        snapshot.appendItems(items, toSection: .image)
        apply(snapshot, animatingDifferences: false)
    }
}



