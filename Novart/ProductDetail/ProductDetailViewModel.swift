//
//  ProductDetailViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/07.
//

import UIKit
import Combine
import Kingfisher

final class ProductDetailViewModel {
    weak var coordinator: ProductDetailCoordinator?
    private let interactor: ProductDetailInteractor = .init()
    
    let productId: Int64
    
    let productDetailSubject: PassthroughSubject<ProductDetailModel, Never> = .init()
    let productImages: PassthroughSubject<[UIImage?], Never> = .init()
    
    init(productId: Int64, coordinator: ProductDetailCoordinator) {
        self.coordinator = coordinator
        self.productId = productId
    }
    
    @MainActor
    func showCommentViewController() {
        print(coordinator != nil)
        coordinator?.navigate(to: .comment)
    }
}

extension ProductDetailViewModel {
    
    func loadData() {
        Task { [weak self] in
            do {
                guard let self else { return }
                let productDetail = try await interactor.fetchProductDetail(id: self.productId)
                self.productDetailSubject.send(productDetail)
                
                let images = try await downloadImages(from: productDetail.artImageUrls)
                self.productImages.send(images)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func downloadImage(from urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let imageResult):
                    continuation.resume(returning: imageResult.image)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func downloadImages(from urlStrings: [String]) async throws -> [UIImage?] {
        var images: [UIImage?] = []

        try await withThrowingTaskGroup(of: UIImage?.self) { [weak self] group in
            guard let self else { return }
            for urlString in urlStrings {
                group.addTask {
                    try await self.downloadImage(from: urlString)
                }
            }

            for try await image in group {
                images.append(image)
            }
        }

        return images
    }
}
