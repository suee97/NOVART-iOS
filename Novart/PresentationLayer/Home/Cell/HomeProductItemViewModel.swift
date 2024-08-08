//
//  FeedItemViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/08/19.
//

import Foundation
import Combine

final class HomeProductItemViewModel: Identifiable, Hashable {
    static func == (lhs: HomeProductItemViewModel, rhs: HomeProductItemViewModel) -> Bool {
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
    
    func changeLikeStatue(likeStatus: HomeFeedLikeStatusModel) {
        self.liked = likeStatus.isLike
    }
}
