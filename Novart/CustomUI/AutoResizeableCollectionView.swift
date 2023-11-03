//
//  AutoResizeableCollectionView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/22.
//

import UIKit

final class AutoResizableCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
