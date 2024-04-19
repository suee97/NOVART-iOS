//
//  FeedItemViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/08/19.
//

import Foundation
import Combine

final class FeedItemViewModel: Identifiable, Hashable {
    static func == (lhs: FeedItemViewModel, rhs: FeedItemViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(imageUrls)
    }
    
    var id: Int64
    let name: String
    let artist: String
    let imageUrls: [String]
    var loopedImageUrls: [String]
    let category: CategoryType
    @Published var liked: Bool = false
    
    let productInteractor: ProductInteractor = .init()
    
    func dataProvider(index: Int) -> String {
        return loopedImageUrls[index]
    }
    
    init(_ item: FeedItem) {
        self.id = item.id
        self.name = item.name
        self.artist = item.nickname
        self.imageUrls = item.thumbnailImageUrl.map { $0.url }
        if self.imageUrls.count > 1 {
            self.loopedImageUrls = self.imageUrls + self.imageUrls + self.imageUrls
        } else {
            self.loopedImageUrls = self.imageUrls
        }
        self.category = item.category
        self.liked = item.likes
    }
    
    func didTapLikeButton() {
        if !Authentication.shared.isLoggedIn {
            NotificationCenter.default.post(name: .init(NotificationKeys.showLoginModalKey), object: nil)
        } else {
            if liked {
                liked = false
                makeCancelLikeRequest()
            } else {
                liked = true
                makeLikeRequest()
            }
        }
    }
    
    func makeLikeRequest() {
        Task {
            do {
                try await productInteractor.likeProduct(id: id)
            } catch {
                liked = false
            }
        }
    }
    
    func makeCancelLikeRequest() {
        Task {
            do {
                try await productInteractor.cancelLikeProduct(id: id)
            } catch {
                liked = true
            }
        }
    }
}
