//
//  RecommendationDataSource.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/22.
//

import UIKit

typealias RecommendationDataSourceType = UICollectionViewDiffableDataSource<RecommendationDataSource.Section, PlainItem>
private typealias RecommendationDataSourceeSnapshot = NSDiffableDataSourceSnapshot<RecommendationDataSource.Section, PlainItem>

private typealias ProductCellRegistration = UICollectionView.CellRegistration<SearchProductCell, SearchProductModel>
private typealias ExhibitionCellRegistration = UICollectionView.CellRegistration<ExhibitionCell, ExhibitionModel>

final class RecommendationDataSource: RecommendationDataSourceType {

    static let sectionHeaderElementKind = "RecommendationSectionHeader"
    
    // MARK: - Section
    enum Section: Int, CaseIterable, Hashable {
        case artistProduct
        case artistExhibition
        case similarProduct
    }
    
    init(collectionView: UICollectionView) {
        let productCellRegistration = ProductCellRegistration { cell, _, item in
            cell.update(with: item)
        }
        
        let exhibitionCellRegistration = ExhibitionCellRegistration { cell, _, item in
            cell.update(with: item)
        }
        super.init(collectionView: collectionView) { collectionView, indexPath, item in
            
            switch item {
            case let productItem as SearchProductModel:
                return collectionView.dequeueConfiguredReusableCell(using: productCellRegistration, for: indexPath, item: productItem)
            case let exhibitionItem as ExhibitionModel:
                return collectionView.dequeueConfiguredReusableCell(using: exhibitionCellRegistration, for: indexPath, item: exhibitionItem)
            default:
                return UICollectionViewCell()
            }
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<RecommendationSectionHeaderView>(elementKind: RecommendationDataSource.sectionHeaderElementKind) { supplementaryView, _, indexPath in
            guard let section = RecommendationDataSource.Section(rawValue: indexPath.section) else { return }
            switch section {
            case .artistProduct:
                supplementaryView.title = "작가의 다른 작품"
            case .artistExhibition:
                supplementaryView.title = "작가가 참여한 전시"
            case .similarProduct:
                supplementaryView.title = "비슷한 유형의 작품"
            }
        }
        
        supplementaryViewProvider = { (collectionView, _, indexPath) -> UICollectionReusableView? in
            collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    func apply(_ items: [RecommendationDataSource.Section: [PlainItem]]) {
        var snapshot = snapshot()
        
        snapshot.deleteSections([.artistProduct])
        snapshot.deleteSections([.artistExhibition])
        snapshot.deleteSections([.similarProduct])
        
        snapshot.appendSections([.artistProduct])
        snapshot.appendSections([.artistExhibition])
        snapshot.appendSections([.similarProduct])
        
        snapshot.appendItems(items[.artistProduct] ?? [], toSection: .artistProduct)
        snapshot.appendItems(items[.artistExhibition] ?? [], toSection: .artistExhibition)
        snapshot.appendItems(items[.similarProduct] ?? [], toSection: .similarProduct)
        apply(snapshot, animatingDifferences: false)
    }
}

