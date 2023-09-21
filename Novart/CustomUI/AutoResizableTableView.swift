//
//  AutoResizableTableView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/09/08.
//

import UIKit

final class AutoResizableTableView: UITableView {
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
