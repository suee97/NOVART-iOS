//
//  FeedImageDataSource.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/08/19.
//

import UIKit

typealias FeedImageDataSourceType = UICollectionViewDiffableDataSource<FeedImageDataSource.Section, String>

private typealias FeedImageDataSourceSnapshot = NSDiffableDataSourceSnapshot<HomeDataSource.Section, String>
private typealias FeedImageCellRegistration = UICollectionView.CellRegistration<FeedImageCell, String>

final class FeedImageDataSource: FeedImageDataSourceType {

    // MARK: - Section
    enum Section: Int, CaseIterable, Hashable {
        case image
    }
    
    init(collectionView: UICollectionView) {
        let feedImageCellRegistration = FeedImageCellRegistration { cell, _, item in
            cell.update(with: item)
        }
        
        super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: feedImageCellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    func apply(_ items: [String]) {
        var snapshot = snapshot()
        
        snapshot.deleteSections([.image])
        snapshot.appendSections([.image])
        
        snapshot.appendItems(items, toSection: .image)
        apply(snapshot, animatingDifferences: false)
    }
}



