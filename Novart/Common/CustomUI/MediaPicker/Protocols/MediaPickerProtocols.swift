//
//  MediaPickerProtocols.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/10.
//

import UIKit
import Photos

// MARK: public

public protocol MediaAssetCollectionInfoble: AnyObject {
    
    var title: String? { get set }
    var identifier: String? { get set }
    var collection: MediaAssetCollection? { get set }
    var assetFetchResult: MediaFetchResult<MediaAsset>? { get set }
    var count: Int { get }
    var thumbnail: UIImage? { get }
    var isEmpty: Bool { get }
}

public protocol MediaPickingInfoable {
    var localIdentifier: String? { get }
    var loadImage: UIImage { get }
    var imageOriginalData: Data? { get }
    var mediaMetadata: [AnyHashable: Any] { get set }
    var mediaAsset: MediaAsset? { get set }
    var mediaType: MediaAssetMediaType { get } 
}

