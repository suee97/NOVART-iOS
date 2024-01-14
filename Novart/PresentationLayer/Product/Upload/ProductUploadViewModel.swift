//
//  ProductUploadViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/10.
//

import UIKit
import Combine

final class ProductUploadViewModel {
    private weak var coordinator: ProductUploadCoordinator?
    
    let step: UploadImageType
    
    @Published var selectedCoverImages: [UploadMediaItem] = []
    private var selectedCoverIdentifiers: [String] = []
    @Published var selectedDetailImages: [UploadMediaItem] = []
    private var selectedDetailIdentifiers: [String] = []
    @Published var isNextEnabled: Bool = false
    
    init(coordinator: ProductUploadCoordinator?, coverImages: [UploadMediaItem]? = nil) {
        self.coordinator = coordinator
        if let coverImages {
            self.step = .detail
            selectedCoverImages = coverImages
        } else {
            self.step = .cover
        }
    }
    
    @MainActor
    func setAsMediaPresenter(viewController: ProductUploadViewController) {
        coordinator?.setAsMediaPickerPresenter(viewController: viewController)
    }
    
    @MainActor
    func closeCoordinator() {
        coordinator?.close()
    }
    
    @MainActor
    func moveToDetailImageUpload() {
        coordinator?.navigate(to: .detailImage(coverImages: selectedCoverImages))
    }
    
    @MainActor
    func moveToDetailInfoUpload() {
        coordinator?.navigate(to: .detailInfo(coverImages: selectedCoverImages, detailImage: selectedDetailImages))
    }
    
    @MainActor
    func showImageEditScene(identifier: String) {
        guard step == .cover else { return }
        guard let image = selectedCoverImages.first(where: { $0.identifier == identifier }) else { return }
        coordinator?.navigate(to: .imageEdit(image: image))
    }
    
    func showMediaPicker() {
        let preselectedIdentifiers: [String] = step == .cover ? selectedCoverIdentifiers : selectedDetailIdentifiers
        coordinator?.showMediaPicker(preselectedIdentifiers: preselectedIdentifiers, mediaPickerSelectionBlock: { [weak self] medias in
            guard let self else { return }
            switch self.step {
            case .cover:
                if medias.identifiers.count <= 3 {
                    let prevSelectedCount = selectedCoverIdentifiers.count
                    selectedCoverIdentifiers = medias.identifiers
                    var coverItems: [UploadMediaItem] = []
                    for (idx, info) in medias.infos.enumerated() {
                        let uploadItem = UploadMediaItem(image: info.loadImage,
                                                         identifier: medias.identifiers[idx + prevSelectedCount],
                                                         width: info.loadImage.size.width,
                                                         height: info.loadImage.size.height)
                        coverItems.append(uploadItem)
                    }
                    self.selectedCoverImages.append(contentsOf: coverItems)
                    self.isNextEnabled = true
                }
            case .detail:
                if !medias.identifiers.isEmpty {
                    let prevSelectedCount = selectedDetailIdentifiers.count
                    selectedDetailIdentifiers = medias.identifiers
                    var detailItems: [UploadMediaItem] = []
                    for (idx, info) in medias.infos.enumerated() {
                        let uploadItem = UploadMediaItem(image: info.loadImage,
                                                         identifier: medias.identifiers[idx+prevSelectedCount],
                                                         width: info.loadImage.size.width,
                                                         height: info.loadImage.size.height)
                        detailItems.append(uploadItem)
                    }
                    self.selectedDetailImages.append(contentsOf: detailItems)
                    self.isNextEnabled = true
                }
            }
        })
    }
    
    func removeItem(identifier: String) {
        switch step {
        case .cover:
            selectedCoverImages.removeAll { $0.identifier == identifier }
            selectedCoverIdentifiers.removeAll { $0 == identifier }
        case .detail:
            selectedDetailImages.removeAll { $0.identifier == identifier }
            selectedDetailIdentifiers.removeAll { $0 == identifier }
        }
    }
}

extension ProductUploadViewModel {
    func didFinishImageCrop(image: UIImage, identifier: String) {
        guard let idx = selectedCoverImages.firstIndex(where: { $0.identifier == identifier }) else { return }
        selectedCoverImages.remove(at: idx)
        let croppedItem = UploadMediaItem(image: image, identifier: identifier, width: image.size.width, height: image.size.height)
        selectedCoverImages.insert(croppedItem, at: idx)
    }
}
