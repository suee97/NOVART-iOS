//
//  PHAssetInteractor.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/10.
//

import Foundation
import Photos
import UIKit

public enum PHAssetInteractorError: Error {
    
    case loadFailed
    case loadCancel
    case needNetworkAccess
    
}

public protocol PHAssetInteractorDelegate: AnyObject {
    
    func photoLibraryDidChange(changeInstance: MediaChange)
    
}

public class PHAssetInteractor: NSObject {

    static private let cachingImageManager = PHCachingImageManager()

    private let worker = PHAssetWorker()
    
    public weak var delegate: PHAssetInteractorDelegate?
    
    public override init() {
        // init
        super.init()
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
        PHAssetInteractor.resetCachedAssets()
    }
    
    public func fetchAssetCollections(subTypes: [PHAssetCollectionSubtype] = [.smartAlbumUserLibrary], isFetchUserAlbum: Bool) async throws -> [MediaAssetCollectionInfoble] {
        var collectionInfos: [MediaAssetCollectionInfoble] = []
        
        // smartAlbum
        for subType in subTypes {
            if let fetchResult = try await worker.fetchCollection(mainType: .smartAlbum, subType: subType), let collection = fetchResult.firstObject {
                let asset = try await worker.fetchAssets(collection: collection)
                var thumbnail: UIImage?
                if let firstAsset = asset.firstObject {
                    thumbnail = try await PHAssetInteractor.loadImage(asset: firstAsset, targetSizeType: .thumbnail)
                }
                let collectionInfo = MediaAssetCollectionInfo(title: collection.localizedTitle, identifier: collection.localIdentifier, collection: collection, assetFetchResult: asset, thumbnail: thumbnail)
                collectionInfos.append(collectionInfo)
            }
        }
        
        // userAlbum
        if isFetchUserAlbum {
            if let fetchResult = try await worker.fetchUserAlbumCollections() {
                var userCollections: [PHAssetCollection] = []
                fetchResult.enumerateObjects { collection, _, _ in
                    userCollections.append(collection)
                }
                for collection in userCollections {
                    let asset = try await worker.fetchAssets(collection: collection)
                    var thumbnail: UIImage?
                    if let firstAsset = asset.firstObject {
                        thumbnail = try await PHAssetInteractor.loadImage(asset: firstAsset, targetSizeType: .thumbnail)
                    }
                    let collectionInfo = MediaAssetCollectionInfo(title: collection.localizedTitle, identifier: collection.localIdentifier, collection: collection, assetFetchResult: asset, thumbnail: thumbnail)
                    collectionInfos.append(collectionInfo)
                }
            }
        }
        
        return collectionInfos
    }
    
    func fetchAsset(withLocalIdentifiers: [String], options: PHFetchOptions? = nil) async throws -> PHAsset? {
        try await worker.fetchAssets(withLocalIdentifiers: withLocalIdentifiers, options: options).firstObject
    }
    
    public func checkAuthorizationStatus() async -> Bool {
        var status = worker.authorizationStatus()
        
        if case .notDetermined = worker.authorizationStatus() {
            status = await worker.requestAuthorization()
        }
        
        return await validAuthorization(status)
    }
    
    private func validAuthorization(_ status: PHAuthorizationStatus) async -> Bool {
        switch status {
        case .authorized:
            return true
        default:
            // PHPicker에서 limited로 했을 때 delegate가 오지 않음
            return false
        }
    }
}

// MARK: - Static Function

public extension PHAssetInteractor {

    static func startCachedAssets(assets: [PHAsset], targetSizeType: MediaPhotoSizeType = MediaPhotoSizeType.maximum) {
        PHAssetInteractor.cachingImageManager.startCachingImages(for: assets, targetSize: targetSizeType.targetSize, contentMode: .aspectFill, options: nil)
    }

    static func stopCachedAssets(assets: [PHAsset], targetSizeType: MediaPhotoSizeType = MediaPhotoSizeType.maximum) {
        PHAssetInteractor.cachingImageManager.stopCachingImages(for: assets, targetSize: targetSizeType.targetSize, contentMode: .aspectFill, options: nil)
    }

    static func resetCachedAssets() {
        PHAssetInteractor.cachingImageManager.stopCachingImagesForAllAssets()
    }

    static func loadImage(asset: PHAsset, targetSizeType: MediaPhotoSizeType = MediaPhotoSizeType.maximum, isNetworkAccess: Bool = false) async throws -> UIImage {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.isNetworkAccessAllowed = isNetworkAccess
        if targetSizeType.isHighQuality {
            options.deliveryMode = .highQualityFormat
        }
        return try await withCheckedThrowingContinuation({ checkedContinuation in
            PHAssetInteractor.cachingImageManager.requestImage(for: asset, targetSize: targetSizeType.targetSize, contentMode: .aspectFill, options: options) { loadImage, imageInfo in
                if let degraded = imageInfo?[PHImageResultIsDegradedKey] as? Bool, degraded == true {
                    return
                }
                if let cancelle = imageInfo?[PHImageCancelledKey] as? Bool, cancelle == true {
                    checkedContinuation.resume(throwing: PHAssetInteractorError.loadCancel)
                    return
                }
                if let error = imageInfo?[PHImageErrorKey] as? PHPhotosError {
                    switch error.code {
                    case .networkAccessRequired:
                        checkedContinuation.resume(throwing: PHAssetInteractorError.needNetworkAccess)
                    default:
                        checkedContinuation.resume(throwing: error)
                    }
                }
                
                guard let loadImage = loadImage else {
                    checkedContinuation.resume(throwing: PHAssetInteractorError.loadFailed)
                    return
                }
                checkedContinuation.resume(returning: loadImage)
            }
        })
    }
    
    static func loadImageAndMetaData(asset: PHAsset, targetSizeType: MediaPhotoSizeType = MediaPhotoSizeType.maximum, isNetworkAccess: Bool = false) async throws -> (UIImage, [String: Any]) {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.isNetworkAccessAllowed = isNetworkAccess
        if targetSizeType.isHighQuality {
            options.deliveryMode = .highQualityFormat
        }
        return try await withCheckedThrowingContinuation({ checkedContinuation in
            PHAssetInteractor.cachingImageManager.requestImageDataAndOrientation(for: asset, options: options) { imageData, dataUTI, orientation, imageInfo in
                if let degraded = imageInfo?[PHImageResultIsDegradedKey] as? Bool, degraded == true {
                    return
                }
                if let cancelle = imageInfo?[PHImageCancelledKey] as? Bool, cancelle == true {
                    checkedContinuation.resume(throwing: PHAssetInteractorError.loadCancel)
                    return
                }
                if let error = imageInfo?[PHImageErrorKey] as? PHPhotosError {
                    switch error.code {
                    case .networkAccessRequired:
                        checkedContinuation.resume(throwing: PHAssetInteractorError.needNetworkAccess)
                        return
                    default:
                        checkedContinuation.resume(throwing: error)
                        return
                    }
                }
                
                guard let imageData = imageData, let loadImage = UIImage(data: imageData) else {
                    checkedContinuation.resume(throwing: PHAssetInteractorError.loadFailed)
                    return
                }
                
                guard let options = [kCGImageSourceShouldCache: kCFBooleanFalse] as? CFDictionary,
                      let imgSrc = CGImageSourceCreateWithData(imageData as NSData, options),
                      let metadata = CGImageSourceCopyPropertiesAtIndex(imgSrc, 0, options as CFDictionary) as? [String: Any] else {
                    checkedContinuation.resume(throwing: PHAssetInteractorError.loadFailed)
                    return
                }
                
                checkedContinuation.resume(returning: (loadImage, metadata))
            }
        })
    }
}

// MARK: - PHPhotoLibraryChangeObserver

extension PHAssetInteractor: PHPhotoLibraryChangeObserver {

    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        delegate?.photoLibraryDidChange(changeInstance: changeInstance)
    }
}
