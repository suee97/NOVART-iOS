//
//  BottomSheetConfiguration.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/02/11.
//

import UIKit

public struct BottomSheetConfiguration {
    
    public enum ContentMode {
        case full
        case half
        case fullAndHalf
    }
    
    public var customHeight: CGFloat = 300
    
    public var contentMode: ContentMode = .half
    
    public var isMaxHeightLimited: Bool = false
    
    public var isModalInPresentation: Bool = false
    
    public var preferredCornerRadius: CGFloat = 12
    
    public var largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    
    public var prefersScrollingExpandsWhenScrolledToEdge: Bool = false
    
    public var prefersEdgeAttachedInCompactHeight: Bool = true
    
    public var widthFollowsPreferredContentSizeWhenEdgeAttached: Bool = true
    
    private let customMaxHeight = UIScreen.main.bounds.height * 0.8
    
    public init() {}
    
    private func makeCustomDetent() -> UISheetPresentationController.Detent {
        UISheetPresentationController.Detent.custom(identifier: .customHeight) { context in
            let maxHeight = context.maximumDetentValue
            return min(customHeight, isMaxHeightLimited ? customMaxHeight : maxHeight)
        }
    }
    
    private func makeLargeDetent() -> UISheetPresentationController.Detent {
        UISheetPresentationController.Detent.custom(identifier: .customLarge) { context in
            let maxHeight = context.maximumDetentValue
            return isMaxHeightLimited ? customMaxHeight : maxHeight
        }
    }
    
    public func makeDetents() -> [UISheetPresentationController.Detent] {
        switch contentMode {
        case .full:
            return [makeLargeDetent()]
        case .half:
            return [makeCustomDetent()]
        case .fullAndHalf:
            return [makeCustomDetent(), makeLargeDetent()]
        }
    }
    
}

