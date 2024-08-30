//
//  ProductPreviewViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/31.
//

import UIKit
import Combine
import Kingfisher

final class ProductPreviewViewModel {
    private weak var coordinator: ProductUploadCoordinator?
    let productPreviewData: ProductPreviewModel
    let uploadModel: ProductUploadModel
    let isUploadingSubject: PassthroughSubject<Bool, Never> = .init()
    let uploadingSuccessSubject: PassthroughSubject<Void, Never> = .init()
    
    var isEditScene: Bool {
        uploadModel.id != nil
    }
    
    private let interactor = ProductUploadInteractor()
    
    init(productPreviewData: ProductPreviewModel, productModel: ProductUploadModel, coordinator: ProductUploadCoordinator?) {
        self.coordinator = coordinator
        self.uploadModel = productModel
        self.productPreviewData = productPreviewData
        
    }
    
    @MainActor
    func startUploadScene() {
        coordinator?.navigate(to: .upload(data: productPreviewData))
    }
    
    @MainActor
    func didTapUploadButton() {
        if isEditScene {
            updateProduct()
        } else {
            startUploadScene()
        }
    }
    
    @MainActor
    func returnToProductDetail() {
        coordinator?.closeToRoot()
    }
}

extension ProductPreviewViewModel {
    func updateProduct() {
        guard let productId = uploadModel.id else { return }
        Task {
            do {
                isUploadingSubject.send(true)
                let (uploadedThumbmnailUrls, uploadedArtUrls) = try await uploadImages()
                                
                let updateModel = createProductUploadData(thumbnailImageUrls: uploadedThumbmnailUrls, artImageUrls: uploadedArtUrls)
                _ = try await interactor.updateProdcutToServer(product: updateModel, productId: productId)
                uploadingSuccessSubject.send()
            } catch {
                isUploadingSubject.send(false)
                print(error.localizedDescription)
            }
        }
    }
    
    func createProductUploadData(thumbnailImageUrls: [String], artImageUrls: [String]) -> ProductUploadRequestModel {
        let data = productPreviewData
        return ProductUploadRequestModel(name: data.name, price: data.price, category: data.selectedCategory.rawValue, description: data.description, forSale: data.forSale, thumbnailImageUrls: thumbnailImageUrls, artImageUrls: artImageUrls, artTagList: data.artTagList)
    }
    
    func uploadImages() async throws -> ([String], [String]) {
        let imageCompresser = ImageCompresser()
        let imageData = (productPreviewData.coverImages + productPreviewData.detailImages).compactMap {
            imageCompresser.compressImage($0.image, toSizeInMegaBytes: 2)
        }
        
        guard !imageData.isEmpty else {
            return ([], [])
        }
        
        var coverFilenames: [String] = []
        var detailFilenames: [String] = []
        
        let date = Date().toString().replacingOccurrences(of: " ", with: "")
        for idx in 0..<productPreviewData.coverImages.count {
            let filename = "thumbnail_\(date)_\(String(format: "%02d", idx)).jpeg"
            coverFilenames.append(filename)
        }
        
        for idx in 0..<productPreviewData.detailImages.count {
            let filename = "art_\(date)_\(String(format: "%02d", idx)).jpeg"
            detailFilenames.append(filename)
        }
        
        let presignedThumbnailUrls = try await interactor.getPresignedUrls(filenames: coverFilenames)
        let presignedArtUrls = try await interactor.getPresignedUrls(filenames: detailFilenames)
        let joinedUrls = presignedThumbnailUrls + presignedArtUrls
        
        try await interactor.uploadToS3(presignedUrls: joinedUrls.map { $0.presignedUrl }, images: imageData)
        
        return (presignedThumbnailUrls.map { $0.imageUrl }, presignedArtUrls.map { $0.imageUrl })
    }
}
