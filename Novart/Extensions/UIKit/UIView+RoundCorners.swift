//
//  UIView+RoundCorners.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/01/14.
//

import UIKit

extension UIView {
    
    func roundCorners(cornerRadius: CGFloat, maskCorners: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: maskCorners)
    }
}

extension CACornerMask {
    static let all: CACornerMask = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
}
