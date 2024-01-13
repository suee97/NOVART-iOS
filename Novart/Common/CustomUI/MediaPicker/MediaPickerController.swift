//
//  MediaPickerController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/10.
//

import UIKit
import Combine
import PhotosUI

struct MediaPickerSelection {
    var identifiers: [String]
    var infos: [any MediaPickingInfoable]
    
    init(identifiers: [String], infos: [any MediaPickingInfoable]) {
        self.identifiers = identifiers
        self.infos = infos
    }
    
    init() {
        self.infos = []
        self.identifiers = []
    }
    
    mutating func remove(identifier: String) {
        guard let index = identifiers.firstIndex(of: identifier) else { return }
        identifiers.remove(at: index)
        infos.remove(at: index)
    }
}


final class MediaPickerController {
    private lazy var picker: PHPickerViewController = {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.selectionLimit = configuration.selectionLimit
        config.selection = configuration.selectionType
        config.filter = configuration.filter
        config.preselectedAssetIdentifiers = configuration.preselectedAssetIdentifiers
        config.preferredAssetRepresentationMode = .current
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        return picker
    }()
    
    private lazy var interactor: PHAssetInteractor = .init()
    
    var mediaPickerSelectionBlock: ((MediaPickerSelection) -> Void)?
    
    private(set) var configuration: Configuration
    
    init() {
        self.configuration = Configuration()
    }
    
    @MainActor
    public func present(on viewController: UIViewController, animated: Bool) async -> Bool {
        return await MainActor.run {
            viewController.present(picker, animated: animated)
            return true
        }
    }
    
    private func showAuthorizationAlert(on viewController: UIViewController) {
        let alert = UIAlertController(title: "권한", message: "사진에 대한 모든 권한이 필요합니다", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancelAction)
        if let settingURL = URL(string: UIApplication.openSettingsURLString) {
            let settingAction = UIAlertAction(title: "설정", style: .default) { _ in
                UIApplication.shared.open(settingURL)
            }
            alert.addAction(settingAction)
        }
        viewController.present(alert, animated: false)
    }
    
    private func resetPicker() {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.selectionLimit = configuration.selectionLimit
        config.selection = configuration.selectionType
        config.filter = configuration.filter
        config.preselectedAssetIdentifiers = configuration.preselectedAssetIdentifiers
        config.preferredAssetRepresentationMode = .current
        picker = PHPickerViewController(configuration: config)
        picker.delegate = self
    }
    
    private func deslectPickerItems() {
        resetPicker()
    }
    
    public func reconfigure(configuration: Configuration) {
        self.configuration = configuration
        resetPicker()
    }
}

extension MediaPickerController {
    // PHPickerFilter
    // available in iOS 16.0 : bursts, cinematicVideos, cinematicVideos, depthEffectPhotos
    // available now : .images, .livePhotos, .panoramas, .screenRecordings, .screenshots, .slomoVideos, .timelapseVideos
    
    struct Configuration {
        static let chooseOnePhoto = Configuration(selectionLimit: 1, selectionType: .default, filter: .images)

        var selectionLimit: Int
        var selectionType: PHPickerConfiguration.Selection
        var filter: PHPickerFilter?
        var mediaPhtoSizeType: MediaPhotoSizeType
        var preselectedAssetIdentifiers: [String]
        
        init(
            selectionLimit: Int = 0,
            selectionType: PHPickerConfiguration.Selection = .ordered,
            filter: PHPickerFilter? = nil,
            mediaPhtoSizeType: MediaPhotoSizeType = .maximum,
            preselectedAssetIdentifiers: [String] = []
        ) {
            self.selectionLimit = selectionLimit
            self.selectionType = selectionType
            self.filter = filter
            self.mediaPhtoSizeType = mediaPhtoSizeType
            self.preselectedAssetIdentifiers = preselectedAssetIdentifiers
        }
    }
}

extension MediaPickerController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let identifiers = results.compactMap { $0.assetIdentifier }
        
        Task {
            var pickingMedias: [any MediaPickingInfoable] = []
            for result in results {
                let identifier = result.assetIdentifier
                let provider = result.itemProvider

                if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                    guard let item = await provider.loadImageItem(localIdentifier: identifier) else { continue }
                    pickingMedias.append(item)
                } else if provider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                    guard let item = try? await provider.loadVideoItem(localIdentifier: identifier) else { continue }
                    pickingMedias.append(item)
                }
            }
            
            mediaPickerSelectionBlock?(.init(identifiers: identifiers, infos: pickingMedias))
            
            if !identifiers.isEmpty {
                if #available(iOS 16, *) {
                    picker.deselectAssets(withIdentifiers: identifiers)
                } else {
                    deslectPickerItems()
                }
            }

            await MainActor.run {
                picker.dismiss(animated: true)
            }
        }
    }
}

private extension NSItemProvider {
    func loadImageItem(localIdentifier: String?) async -> (any MediaPickingInfoable)? {
        guard let url = await getFileURL(for: .image) else {
            return nil
        }
        return await withCheckedContinuation { continuation in
            loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, _ in
                guard let data else {
                    continuation.resume(returning: nil)
                    return
                }
                
                if let image = UIImage(data: data) {
                    let mediaMetadata: [String: Any] = [
                        MediaMetadataKeys.size: UInt64(data.count),
                        MediaMetadataKeys.url: url,
                        MediaMetadataKeys.filenameExtension: url.pathExtension
                    ]
                    
                    let media = PickingMediaInfo(localIdentifier: localIdentifier, loadImage: image, imageOriginalData: data, mediaMetadata: mediaMetadata, mediaType: .image)
                    continuation.resume(returning: media)
                    return
                }
                
                continuation.resume(returning: nil)
            }
        }
    }
    
    func loadVideoItem(localIdentifier: String?) async throws -> (any MediaPickingInfoable)? {
        guard let url = await moveVideoFileToTemp() else { return nil }

        let avAsset = AVAsset(url: url)
        guard let image = try? await avAsset.thumbnailImage else { return nil }

        guard let thumbnailUrl = saveVideoThumbnailToTemp(image: image, filename: url.lastPathComponent) else { return nil }
        
        let duration: TimeInterval = ( try? await avAsset.videoDuration ) ?? 0
        let fileAttributes = try? FileManager.default.attributesOfItem(atPath: url.relativePath)
        let fileSize = fileAttributes?[FileAttributeKey.size] as? UInt64 ?? 0
        
        let mediaMetadata: [String: Any] = [
            MediaMetadataKeys.url: url,
            MediaMetadataKeys.duration: duration,
            MediaMetadataKeys.size: fileSize,
            MediaMetadataKeys.thumbnailUrl: thumbnailUrl
        ]

        let media = PickingMediaInfo(localIdentifier: localIdentifier, loadImage: image, mediaMetadata: mediaMetadata, mediaType: .video)
        return media
    }
    
    func getFileURL(for type: UTType) async -> URL? {
        return await withCheckedContinuation { continuation in
            loadFileRepresentation(forTypeIdentifier: type.identifier) { url, _ in
                guard let url else {
                    continuation.resume(returning: nil)
                    return
                }
                
                continuation.resume(returning: url)
            }
        }
    }

    func moveVideoFileToTemp() async -> URL? {
        return await withCheckedContinuation { continuation in
            loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, _ in
                guard let url else {
                    continuation.resume(returning: nil)
                    return
                }
                
                let tempDirectory = FileManager.default.temporaryDirectory
                let tempUrl = tempDirectory.appendingPathComponent(url.lastPathComponent)
                
                if FileManager.default.fileExists(atPath: tempUrl.relativePath) {
                    try? FileManager.default.removeItem(atPath: tempUrl.relativePath)
                }

                do {
                    try FileManager.default.copyItem(at: url, to: tempUrl)
                    print("copy to temp directory success!! \(tempUrl)")
                } catch {
                    print("copy to temp directory failed!! \(error)")
                }

                continuation.resume(returning: tempUrl)
            }
        }
    }
    
    func saveVideoThumbnailToTemp(image: UIImage, filename: String) -> URL? {
        guard let imageData = image.pngData() else {
            print("Save thumbnail image failed")
            return nil
        }
        
        let tempDirectory = FileManager.default.temporaryDirectory
        let tempUrlString = tempDirectory.appendingPathComponent(filename).deletingPathExtension().absoluteString + "-thumbnail.png"
        
        guard let tempURL = URL(string: tempUrlString) else {
            print("Generate thumbnail image url failed")
            return nil
        }
        
        do {
            try imageData.write(to: tempURL)
            print("Save video thumbnail image success")
            return tempURL
        } catch {
            print("Save thumbnail image failed")
            return nil
        }
    }
}
