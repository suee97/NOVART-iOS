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
    let recommendDataSubject: PassthroughSubject<ProductDetailRecommendData, Never> = .init()
    let isLikedSubject: CurrentValueSubject<Bool, Never> = .init(false)
    let isFollowingSubject: CurrentValueSubject<Bool, Never> = .init(false)
    var coverImageData: [RetrieveImageData] = []
    var detailImageData: [UIImage] = []
    let imageRetrieveQueue = DispatchQueue(label: "imageQueue", qos: .utility)
    
    var didEnterEdit: Bool = false
    
    var isFollowingArtist: Bool {
        productDetailSubject.value?.artist.following ?? false
    }
    
    var isMine: Bool {
        let artistId = productDetailSubject.value?.artist.userId ?? -1
        return Authentication.shared.user?.id == artistId
    }
    
    var isContactEnabled: Bool {
        guard let productModel = productDetailSubject.value else { return false }
        if (productModel.artist.email != nil) || (productModel.artist.openChatUrl != nil) {
            return true
        } else {
            return false
        }
    }
    
    init(productId: Int64, coordinator: ProductDetailCoordinator) {
        self.coordinator = coordinator
        self.productId = productId
    }
    
    @MainActor
    func closeCoordinator() {
        coordinator?.close()
    }
    
    func viewWillAppear() {
        if didEnterEdit {
            didEnterEdit = false
            loadData()
        }
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
                
                async let downloadImages = downloadImages(from: productDetail.artImageUrls)
                async let fetchRelatedProducts = interactor.fetchRelatedProducts(id: self.productId)
                async let fetchOtherProducts = interactor.fetchOtherProductsFromArtist(productId: productId, artistId: productDetail.artist.userId)
                async let fetchExhibitions = interactor.fetchExhibitions(artistId: productDetail.artist.userId)
                
                self.productDetailSubject.send(productDetail)
                self.isLikedSubject.send(productDetail.likes)
                self.isFollowingSubject.send(productDetail.artist.following)
                
                let images = try await downloadImages
                self.detailImageData = images.compactMap { $0 }
                self.productImages.send(images)
                
                let relatedProducts = try await fetchRelatedProducts
                let otherProducts = try await fetchOtherProducts
                let exhibitions = try await fetchExhibitions
                
                let recommendData = ProductDetailRecommendData(relatedProducts: relatedProducts, otherProducts: otherProducts, exhibitions: exhibitions)
                self.recommendDataSubject.send(recommendData)
                
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
    
    @MainActor
    func didTapFollowButton() {
        if !Authentication.shared.isLoggedIn {
            coordinator?.navigate(to: .login)
        } else {
            if isFollowingSubject.value {
                isFollowingSubject.send(false)
                makeCancelFollowRequest()
            } else {
                isFollowingSubject.send(true)
                makeFollowRequest()
            }
        }
    }
    
    @MainActor
    func didTapContactButton() {
        
        if !Authentication.shared.isLoggedIn {
            coordinator?.navigate(to: .login)
        } else {
            guard let product = productDetailSubject.value else { return }
            let user = convertArtistToUserModel(prouctModel: product)
            coordinator?.navigate(to: .ask(user: user))
        }
    }
    
    @MainActor
    func didTapLikeButton() {
        if !Authentication.shared.isLoggedIn {
            coordinator?.navigate(to: .login)
        } else {
            if isLikedSubject.value {
                isLikedSubject.send(false)
                makeCancelLikeRequest()
            } else {
                isLikedSubject.send(true)
                makeLikeRequest()
            }
        }
    }
    
    func didTapShareButton() {
        showActivityController()
    }
    
    @MainActor
    func didTapCommentButton() {
        showCommentViewController()
    }
    
    @MainActor
    func didTapMoreButton() {
        if !Authentication.shared.isLoggedIn {
            coordinator?.navigate(to: .login)
        } else {
            showMoreActionSheet()
        }
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
    
    @MainActor
    func showProductEditScene() {
        guard let productModel = productDetailSubject.value else { return }
        let sortedCoverImages = coverImageData.sorted { $0.index < $1.index }
        var coverImages: [UploadMediaItem] = []
        for (idx, image) in sortedCoverImages.enumerated() {
            coverImages.append(UploadMediaItem(image: image.image, identifier: productDetailSubject.value?.thumbnailImageUrls[idx] ?? "\(Date.now)_\(idx)", width: image.image.size.width, height: image.image.size.height))
        }
        var detailImages: [UploadMediaItem] = []
        for (idx, image) in detailImageData.enumerated() {
            detailImages.append(UploadMediaItem(image: image, identifier: productDetailSubject.value?.artImageUrls[idx] ?? "\(Date.now)_\(idx)", width: image.size.width, height: image.size.height))
        }

        let productEditModel = ProductUploadModel(
            id: productModel.id,
            name: productModel.name,
            description: productModel.description,
            price: productModel.price,
            coverImages: coverImages,
            detailImages: detailImages,
            artTagList: productModel.artTagList,
            forSale: productModel.forSale,
            category: productModel.category
        )
        
        didEnterEdit = true
        coordinator?.navigate(to: .edit(product: productEditModel))
    }
    
    @MainActor
    func showReportSheet() {
        coordinator?.navigate(to: .report)
    }
    
    @MainActor
    func showSearchResultFor(query: String) {
        coordinator?.navigate(to: .search(query: query))
    }
    
    @MainActor
    func didTapTag(at index: Int) {
        guard let detailModel = productDetailSubject.value else { return }
        let tag = detailModel.artTagList[index]
        showSearchResultFor(query: tag)
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
    
    func deleteProduct() {
        Task {
            do {
                try await productInteractor.deleteProduct(id: productId)
                await closeCoordinator()
            } catch {
                print(error.localizedDescription)
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
        
        let alertController = AlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if isMine {
            let editAction = AlertAction(title: "작품 편집", style: .default) { [weak self] _ in
                DispatchQueue.main.async {
                    self?.showProductEditScene()
                }
            }
            let deleteAction = AlertAction(title: "작품 삭제", style: .destructive) { [weak self] _ in
                self?.deleteProduct()
            }
            
            alertController.addAction(editAction)
            alertController.addAction(deleteAction)
            
        } else {
            let reportAction = AlertAction(title: "신고하기", style: .destructive) { [weak self] _ in
                DispatchQueue.main.async {
                    self?.showReportSheet()
                }
            }
            alertController.addAction(reportAction)
        }
        
        alertController.addCancelAction()
        alertController.show()
    }
}

extension ProductDetailViewModel {
    func imageRetrieveHandler(image: RetrieveImageData) {
        imageRetrieveQueue.async { [weak self] in
            self?.coverImageData.append(image)
        }
    }
}

extension ProductDetailViewModel {
    private func convertArtistToUserModel(prouctModel: ProductDetailModel) -> PlainUser {
        let artist = prouctModel.artist
        return PlainUser(
            id: artist.userId,
            nickname: artist.nickname,
            profileImageUrl: artist.profileImageUrl,
            backgroundImageUrl: nil,
            tags: [],
            jobs: [],
            email: prouctModel.artist.email,
            openChatUrl: prouctModel.artist.openChatUrl,
            following: artist.following
        )
    }
}
