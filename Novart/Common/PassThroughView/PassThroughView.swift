//
//  PassThroughView.swift
//  Novart
//
//  Created by Jinwook Huh on 2/17/24.
//

import UIKit

open class PassthroughView: UIView {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}

open class PassthroughStackView: UIStackView {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}
