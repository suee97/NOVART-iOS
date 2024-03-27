//
//  RecommendationDataSource.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/22.
//

import UIKit

typealias RecommendationDataSourceType = UICollectionViewDiffableDataSource<RecommendationDataSource.Section, PlainItem>
private typealias RecommendationDataSourceSnapshot = NSDiffableDataSourceSnapshot<RecommendationDataSource.Section, PlainItem>

private typealias ProductCellRegistration = UICollectionView.CellRegistration<ProductCell, ProductModel>
private typealias ExhibitionCellRegistration = UICollectionView.CellRegistration<ProductDetailExhibitionCell, ExhibitionModel>

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
            case let productItem as ProductModel:
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
        var snapshot = RecommendationDataSourceSnapshot()
        
        let productItems = items[.artistProduct] ?? []
        let exhibitionItems = items[.artistExhibition] ?? []
        let similarItems = items[.similarProduct] ?? []
        
        if !productItems.isEmpty {
            snapshot.appendSections([.artistProduct])
            snapshot.appendItems(productItems, toSection: .artistProduct)
        }
        
        if !exhibitionItems.isEmpty {
            snapshot.appendSections([.artistExhibition])
            snapshot.appendItems(exhibitionItems, toSection: .artistExhibition)
        }
        
        if !similarItems.isEmpty {
            snapshot.appendSections([.similarProduct])
            snapshot.appendItems(similarItems, toSection: .similarProduct)
        }
    
        apply(snapshot, animatingDifferences: false)
    }
}

