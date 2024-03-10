//
//  ProductImageUploadViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/10.
//

import UIKit
import Combine

final class ProductImageUploadViewModel {
    private weak var coordinator: ProductUploadCoordinator?
    
    let step: UploadStep
    
    private var selectedCoverIdentifiers: [String] = []
    private var selectedDetailIdentifiers: [String] = []
    @Published var isNextEnabled: Bool = false
    var selectedImagesSubject: PassthroughSubject<[UploadMediaItem], Never> = .init()
    
    var previousCoverImages: [UploadMediaItem] = []
    var previousDetailImages: [UploadMediaItem] = []
    var additionalCoverImages: [UploadMediaItem] = []
    var additionalDetailImages: [UploadMediaItem] = []
    @Published var uploadModel: ProductUploadModel
    var isEditScene: Bool {
        uploadModel.id != nil
    }
    
    init(coordinator: ProductUploadCoordinator?, step: UploadStep, uploadModel: ProductUploadModel? = nil) {
        self.coordinator = coordinator
        self.step = step
        if let uploadModel {
            self.uploadModel = uploadModel
            isNextEnabled = true
        } else {
            self.uploadModel = .init()
        }
    }

    @MainActor
    func setAsMediaPresenter(viewController: ProductImageUploadViewController) {
        coordinator?.setAsMediaPickerPresenter(viewController: viewController)
    }
    
    @MainActor
    func closeCoordinator() {
        if isEditScene {
            coordinator?.closeAsPop()
        } else {
            coordinator?.close()
        }
    }
    
    @MainActor
    func moveToDetailImageUpload() {
        coordinator?.navigate(to: .detailImage(productEditModel: uploadModel))
    }
    
    @MainActor
    func moveToDetailInfoUpload() {
        coordinator?.navigate(to: .detailInfo(productEditModel: uploadModel))
    }
    
    @MainActor
    func showImageEditScene(identifier: String) {
        guard step == .coverImage else { return }
        guard let image = uploadModel.getImage(step: step, identifier: identifier)
        else { return }
        coordinator?.navigate(to: .imageEdit(image: image))
    }
    
    func showMediaPicker() {
        let preselectedIdentifiers: [String] = step == .coverImage ? selectedCoverIdentifiers : selectedDetailIdentifiers
        coordinator?.showMediaPicker(preselectedIdentifiers: preselectedIdentifiers, mediaPickerSelectionBlock: { [weak self] medias in
            guard let self else { return }
            switch self.step {
            case .coverImage:
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
                    self.uploadModel.addImages(step: .coverImage, images: coverItems)
                    self.selectedImagesSubject.send(uploadModel.coverImages)
                    self.isNextEnabled = true
                }
            case .detailImage:
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
                    self.uploadModel.addImages(step: .detailImage, images: detailItems)
                    self.selectedImagesSubject.send(uploadModel.detailImages)

                    self.isNextEnabled = true
                }
            }
        })
    }
    
    func removeItem(identifier: String) {
        switch step {
        case .coverImage:
            uploadModel.coverImages.removeAll(where: { $0.identifier == identifier })
            self.selectedImagesSubject.send(uploadModel.coverImages)
        case .detailImage:
            uploadModel.detailImages.removeAll(where: { $0.identifier == identifier })
            self.selectedImagesSubject.send(uploadModel.detailImages)
        }
    }
}

extension ProductImageUploadViewModel {
    func didFinishImageCrop(image: UIImage, identifier: String) {
        let croppedItem = UploadMediaItem(image: image, identifier: identifier, width: image.size.width, height: image.size.height)
        uploadModel.updateImage(step: .coverImage, identifier: identifier, item: croppedItem)
        selectedImagesSubject.send(uploadModel.coverImages)
    }
}


