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
    
    let productDetailSubject: CurrentValueSubject<ProductDetailModel?, Never> = .init(nil)
    let productImages: PassthroughSubject<[UIImage?], Never> = .init()
    
    var isFollowingArtist: Bool {
        productDetailSubject.value?.artist.following ?? false
    }
    
    var isMine: Bool {
        let artistId = productDetailSubject.value?.artist.userId ?? -1
        return Authentication.shared.user?.id == artistId
    }
    
    init(productId: Int64, coordinator: ProductDetailCoordinator) {
        self.coordinator = coordinator
        self.productId = productId
    }
    
    @MainActor
    func showCommentViewController() {
        coordinator?.navigate(to: .comment(productId: productId))
    }
    
    @MainActor
    func closeCoordinator() {
        coordinator?.close()
    }
}

extension ProductDetailViewModel {
    func attributedDescriptionsString(for text: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: 14, weight: .regular),
            .foregroundColor: UIColor.Common.warmBlack
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        return attributedString
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
