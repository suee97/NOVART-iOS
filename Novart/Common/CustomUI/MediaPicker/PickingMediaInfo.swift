//
//  PickingMediaInfo.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/10.
//

import UIKit
import Photos
import Combine

public struct PickingMediaInfo: MediaPickingInfoable {
    public var localIdentifier: String?
    public var loadImage: UIImage
    public var imageOriginalData: Data?
    public var mediaMetadata: [AnyHashable: Any] = [:]
    public var mediaAsset: MediaAsset?
    public var mediaType: MediaAssetMediaType = .unknown
    
}
