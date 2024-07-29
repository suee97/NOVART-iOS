import UIKit

typealias ExhibitionMainDataSourceType = UICollectionViewDiffableDataSource<ExhibitionMainDataSource.Section, ProcessedExhibition>
fileprivate typealias ExhibitionMainDataSourceSnapshot = NSDiffableDataSourceSnapshot<ExhibitionMainDataSource.Section, ProcessedExhibition>
fileprivate typealias ExhibitionMainCellRegistration = UICollectionView.CellRegistration<ExhibitionCell, ProcessedExhibition>

final class ExhibitionMainDataSource: ExhibitionMainDataSourceType {
    enum Section: Int, CaseIterable, Hashable {
        case main
    }
    
    init(collectionView: UICollectionView) {
        let exhibitionMainCellRegistration = ExhibitionMainCellRegistration { cell, _, item in
            cell.exhibition = item
        }
        
        super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: exhibitionMainCellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    func apply(_ items: [ProcessedExhibition]) {
        var snapshot = snapshot()
        snapshot.deleteSections([.main])
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        apply(snapshot, animatingDifferences: false)
    }
}
