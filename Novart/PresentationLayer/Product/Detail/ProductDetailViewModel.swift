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
    private let productInteractor: ProductInteractor = .init()
    private let myPageInteractor: MyPageDownloadInteractor = .init()
    
    let productId: Int64
    
    let productDetailSubject: CurrentValueSubject<ProductDetailModel?, Never> = .init(nil)
    let productImages: PassthroughSubject<[UIImage?], Never> = .init()
    let isLikedSubject: CurrentValueSubject<Bool, Never> = .init(false)
    let isFollowingSubject: CurrentValueSubject<Bool, Never> = .init(false)
    
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
                self.isLikedSubject.send(productDetail.likes)
                self.isFollowingSubject.send(productDetail.artist.following)
                
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
    
    func didTapFollowButton() {
        if isFollowingSubject.value {
            isFollowingSubject.send(false)
            makeCancelFollowRequest()
        } else {
            isFollowingSubject.send(true)
            makeFollowRequest()
        }
    }
    
    func didTapLikeButton() {
        if isLikedSubject.value {
            isLikedSubject.send(false)
            makeCancelLikeRequest()
        } else {
            isLikedSubject.send(true)
            makeLikeRequest()
        }
    }
    
    func didTapShareButton() {
        showActivityController()
    }
    
    @MainActor
    func didTapCommentButton() {
        showCommentViewController()
    }
    
    func didTapMoreButton() {
        showMoreActionSheet()
    }
    
    @MainActor
    func didTapUserProfile() {
        if isMine {
            showMyProfile()
        } else {
            guard let userId = productDetailSubject.value?.artist.userId else { return }
            coordinator?.navigate(to: .artist(userId: userId))
        }
    }
    
    @MainActor
    func didTapMyProfileButton() {
        showMyProfile()
    }
    
    @MainActor
    func showMyProfile() {
        coordinator?.navigate(to: .artist(userId: nil))
    }
}

extension ProductDetailViewModel {
    func makeLikeRequest() {
        Task {
            do {
                try await productInteractor.likeProduct(id: productId)
            } catch {
                isLikedSubject.send(false)
            }
        }
    }
    
    func makeCancelLikeRequest() {
        Task {
            do {
                try await productInteractor.cancelLikeProduct(id: productId)
            } catch {
                isLikedSubject.send(true)
            }
        }
    }
    
    func makeFollowRequest() {
        Task {
            do {
                guard let userId = productDetailSubject.value?.artist.userId else { return }
                _ = try await myPageInteractor.follow(userId: userId)
                DispatchQueue.main.async {
                    PlainSnackbar.show(message: "새로운 작가를 팔로우 했어요!", configuration: .init(imageType: .icon(.check), buttonType: .text("모두 보기"), buttonAction: nil))
                }
            } catch {
                isFollowingSubject.send(false)
            }
        }
    }
    
    func makeCancelFollowRequest() {
        Task {
            do {
                guard let userId = productDetailSubject.value?.artist.userId else { return }
                _ = try await myPageInteractor.unFollow(userId: userId)
            } catch {
                isFollowingSubject.send(true)
            }
        }
    }
}

extension ProductDetailViewModel {
    @MainActor
    func showCommentViewController() {
        coordinator?.navigate(to: .comment(productId: productId))
    }
    
    func showActivityController() {
        let dataToShare = "제품id: \(productId) 공유 됨"
        let activityController = ActivityController(activityItems: [dataToShare], applicationActivities: nil)
        activityController.show()
    }
    
    func showMoreActionSheet() {
        
        let alertController = AlertController(title: nil, attributedMessage: nil, preferredStyle: .actionSheet)

        if isMine {
            let editAction = AlertAction(title: "작품 편집", style: .default) { _ in
                print("작품 편집")
            }
            let deleteAction = AlertAction(title: "작품 삭제", style: .destructive) { _ in
                print("작품 삭제")
            }
            
            alertController.addAction(editAction)
            alertController.addAction(deleteAction)
            
        } else {
            let reportAction = AlertAction(title: "신고하기", style: .destructive) { _ in
                print("신고하기")
            }
            alertController.addAction(reportAction)
        }
        
        alertController.addCancelAction()
        alertController.show()
    }
}
