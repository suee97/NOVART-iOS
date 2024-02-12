//
//  MediaPickerTypeAlias.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/10.
//

import Foundation
import Photos

public typealias MediaAsset = Photos.PHAsset
public typealias MediaChange = Photos.PHChange
public typealias MediaAssetMediaType = Photos.PHAssetMediaType
public typealias MediaAssetCollection = Photos.PHAssetCollection
public typealias MediaFetchResult<T> = Photos.PHFetchResult<T> where T: AnyObject

