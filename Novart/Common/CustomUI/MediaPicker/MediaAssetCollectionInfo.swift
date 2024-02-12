//
//  MediaAssetCollectionInfo.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/10.
//

import UIKit
import Photos

public final class MediaAssetCollectionInfo: MediaAssetCollectionInfoble {

    public var title: String?
    public var identifier: String?
    public var collection: PHAssetCollection?
    public var assetFetchResult: PHFetchResult<PHAsset>?
    public var count: Int {
        assetFetchResult?.count ?? 0
    }
    public var thumbnail: UIImage?
    public var isEmpty: Bool {
        assetFetchResult?.firstObject == nil
    }
    
    required init(title: String?, identifier: String?, collection: PHAssetCollection?, assetFetchResult: PHFetchResult<PHAsset>?, thumbnail: UIImage?) {
        self.title = title
        self.identifier = identifier
        self.collection = collection
        self.assetFetchResult = assetFetchResult
        self.thumbnail = thumbnail
    }
}
