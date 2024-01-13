//
//  PHAssetWorker.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/10.
//

import Foundation
import Photos

public enum PHAssetWorkerError: Error {
    case authorization
    case unknown
}

public struct PHAssetWorker {
    
    public init() {
        // init
    }
    
    public func requestAuthorization() async -> PHAuthorizationStatus {
        await PHPhotoLibrary.requestAuthorization(for: .readWrite)
    }
    
    public func authorizationStatus() -> PHAuthorizationStatus {
        PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
    
    public func fetchAllAssets() async throws -> PHFetchResult<PHAsset> {
        let currentStatus = await requestAuthorization()
        guard currentStatus == .limited || currentStatus == .authorized else {
            throw PHAssetWorkerError.authorization
        }
        return PHAsset.fetchAssets(with: defaultPHFetchOptions())
    }
    
    public func fetchAssets(collection: PHAssetCollection) async throws -> PHFetchResult<PHAsset> {
        let currentStatus = await requestAuthorization()
        guard currentStatus == .limited || currentStatus == .authorized else {
            throw PHAssetWorkerError.authorization
        }
        return PHAsset.fetchAssets(in: collection, options: defaultPHFetchOptions())
    }
    
    public func fetchUserAlbumCollections() async throws -> PHFetchResult<PHAssetCollection>? {
        let currentStatus = await requestAuthorization()
        guard currentStatus == .limited || currentStatus == .authorized else {
            throw PHAssetWorkerError.authorization
        }
        
        return PHCollectionList.fetchTopLevelUserCollections(with: nil) as? PHFetchResult<PHAssetCollection>
    }
    
    public func fetchCollection(mainType: PHAssetCollectionType, subType: PHAssetCollectionSubtype) async throws -> PHFetchResult<PHAssetCollection>? {
        let currentStatus = await requestAuthorization()
        guard currentStatus == .limited || currentStatus == .authorized else {
            throw PHAssetWorkerError.authorization
        }
        return PHAssetCollection.fetchAssetCollections(with: mainType, subtype: subType, options: nil)
    }
    
    public func addAlbum(title: String) async throws {
        let currentStatus = await requestAuthorization()
        guard currentStatus == .authorized else {
            throw PHAssetWorkerError.authorization
        }
        
        guard title.isEmpty == false else {
            throw PHAssetWorkerError.unknown
        }
        
        try await PHPhotoLibrary.shared().performChanges {
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
        }
    }
    
    public func fetchAssets(withLocalIdentifiers: [String], options: PHFetchOptions? = nil) async throws -> PHFetchResult<PHAsset> {
        let currentStatus = await requestAuthorization()
        guard currentStatus == .limited || currentStatus == .authorized else {
            throw PHAssetWorkerError.authorization
        }
        return PHAsset.fetchAssets(withLocalIdentifiers: withLocalIdentifiers, options: options)
    }
}

// MARK: - Private

extension PHAssetWorker {
    
    private func defaultPHFetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.includeAssetSourceTypes = .typeUserLibrary
        fetchOptions.includeHiddenAssets = false

        let imagePredicate = NSPredicate(format: "mediaType = %d || mediaType = %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
        fetchOptions.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [imagePredicate])

        return fetchOptions
    }
    
}
