//
//  UISheenPresentationController+Configuration.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/02/11.
//

import UIKit

extension UISheetPresentationController.Detent.Identifier {
    static let customHeight = UISheetPresentationController.Detent.Identifier("customHeight")
    static let customLarge = UISheetPresentationController.Detent.Identifier("customLarge")
}

extension UISheetPresentationController {
    
    func setConfiguration(_ config: BottomSheetConfiguration) {
        preferredCornerRadius = config.preferredCornerRadius
        prefersGrabberVisible = false
        largestUndimmedDetentIdentifier = config.largestUndimmedDetentIdentifier
        prefersScrollingExpandsWhenScrolledToEdge = config.prefersScrollingExpandsWhenScrolledToEdge
        prefersEdgeAttachedInCompactHeight = config.prefersEdgeAttachedInCompactHeight
        widthFollowsPreferredContentSizeWhenEdgeAttached = config.widthFollowsPreferredContentSizeWhenEdgeAttached
        detents = config.makeDetents()
    }
    
}

