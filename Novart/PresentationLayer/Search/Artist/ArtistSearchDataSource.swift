//
//  ArtistSearchDataSource.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/15.
//

import UIKit

typealias ArtistSearchDataSourceType = UICollectionViewDiffableDataSource<ArtistSearchDataSource.Section, SearchArtistModel>

private typealias ArtistSearchDataSourceSnapshot = NSDiffableDataSourceSnapshot<ArtistSearchDataSource.Section, SearchArtistModel>
private typealias ArtistSearchProductCellRegistration = UICollectionView.CellRegistration<SearchArtistCell, SearchArtistModel>

final class ArtistSearchDataSource: ArtistSearchDataSourceType {

    // MARK: - Section
    enum Section: Int, CaseIterable, Hashable {
        case artist
    }
    
    init(collectionView: UICollectionView) {
        
        let searchArtistCellRegistration = ArtistSearchProductCellRegistration { cell, _, item in
            cell.update(with: item)
        }
        
        super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: searchArtistCellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    func apply(_ items: [SearchArtistModel]) {
        var snapshot = snapshot()
        
        snapshot.deleteSections([.artist])
        snapshot.appendSections([.artist])
        
        snapshot.appendItems(items, toSection: .artist)
        apply(snapshot, animatingDifferences: false)
    }
}
