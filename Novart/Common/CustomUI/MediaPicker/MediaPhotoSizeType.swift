//
//  MediaPhotoSizeType.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/10.
//

import Foundation
import Photos

public enum MediaPhotoSizeType {
    case thumbnail
    case small
    case middle
    case maximum
    case custom(width: CGFloat, height: CGFloat)

    public var targetSize: CGSize {
        // TODO: - thumbnail, small, middle,  임의지정함
        switch self {
        case .thumbnail:
            return CGSize(width: 200, height: 200)
        case .small:
            return CGSize(width: 400, height: 400)
        case .middle:
            return CGSize(width: 800, height: 800)
        case .maximum:
            return PHImageManagerMaximumSize
        case .custom(width: let width, height: let height):
            return CGSize(width: width, height: height)
        }
    }

    public var isHighQuality: Bool {
        switch self {
        case .thumbnail, .small, .middle:
            return false
        default:
            return true
        }
    }
}
