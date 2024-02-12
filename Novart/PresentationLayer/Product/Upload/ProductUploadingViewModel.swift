//
//  ProductUploadingViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/01/01.
//

import Foundation
import Combine

final class ProductUploadingViewModel {
    
    enum State {
        case uploading
        case complete
    }
    
    private weak var coordinator: ProductUploadCoordinator?
    private let interactor = ProductUploadInteractor()
    let uploadedProduct: PassthroughSubject<ProductModel, Never> = .init()
    
    @Published var state: State = .uploading
    
    let uploadingDesription: String = "앱을 종료하면 등록이 최소되니 잠시 기다려주세요"
    let completeDesription: String = "지금 바로 작가님의 작품을 확인해보세요"
    
    var stateText: String {
        switch state {
        case .uploading:
            return "등록 중..."
        case .complete:
            return "등록 완료!"
        }
    }
    
    private let productPreviewData: ProductPreviewModel
    
    init(data: ProductPreviewModel, coordinator: ProductUploadCoordinator?) {
        self.coordinator = coordinator
        self.productPreviewData = data
    }
}

extension ProductUploadingViewModel {
    func uploadProduct() {
        Task {
            do {
                
                let imageData = (productPreviewData.coverImages + productPreviewData.detailImages).compactMap {
                    $0.jpegData(compressionQuality: 0.9)
                }
                
                var thumbnailFilenames: [String] = []
                var artFilenames: [String] = []
                
                let date = Date().toString().replacingOccurrences(of: " ", with: "")
                for idx in 0..<productPreviewData.coverImages.count {
                    let filename = "thumbnail_\(date)_\(String(format: "%02d", idx)).jpeg"
                    thumbnailFilenames.append(filename)
                }
                
                for idx in 0..<productPreviewData.detailImages.count {
                    let filename = "art_\(date)_\(String(format: "%02d", idx)).jpeg"
                    artFilenames.append(filename)
                }
                
                let presignedThumbnailUrls = try await interactor.getPresignedUrls(filenames: thumbnailFilenames)
                let presignedArtUrls = try await interactor.getPresignedUrls(filenames: artFilenames)
                let joinedUrls = presignedThumbnailUrls + presignedArtUrls
                
                try await interactor.uploadToS3(presignedUrls: joinedUrls.map { $0.presignedUrl }, images: imageData)
                let uploadModel = createProductUploadData(thumbnailImageUrls: presignedThumbnailUrls.map { $0.imageUrl }, artImageUrls: presignedArtUrls.map { $0.imageUrl })
                let product = try await interactor.uploadProductToServer(product: uploadModel)
                uploadedProduct.send(product)
                state = .complete
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func createProductUploadData(thumbnailImageUrls: [String], artImageUrls: [String]) -> ProductUploadRequestModel {
        let data = productPreviewData
        return ProductUploadRequestModel(name: data.name, price: data.price, category: data.selectedCategory.rawValue, description: data.description, forSale: data.forSale, thumbnailImageUrls: thumbnailImageUrls, artImageUrls: artImageUrls, artTagList: data.artTagList)
    }
}
