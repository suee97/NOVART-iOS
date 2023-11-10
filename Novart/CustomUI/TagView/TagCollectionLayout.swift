//
//  TagCollectionLayout.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/07.
//

import UIKit

final class TagCollectionLayout: UICollectionViewCompositionalLayout {
    private enum Constants {
        static let itemHeight: CGFloat = 32
        static let itemSpacing: CGFloat = 4
        static let groupSpacing: CGFloat = 4
    }
    
    init() {
        let itemsSize = NSCollectionLayoutSize(widthDimension: .estimated(32), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemsSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(Constants.itemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(Constants.itemSpacing)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constants.groupSpacing
        
        super.init(section: section)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
