import UIKit

// 전시 모델 (from 서버, 임시)
struct Exhibition: Hashable {
    let id: Int
    let imageUrl: String
    let desc: String
    let likeCount: Int
    let commentCount: Int
    let isLike: Bool
}

// 처리 후 전시 모델 (임시)
struct ProcessedExhibition: Hashable {
    let id: Int
    let imageView: UIImageView
    let desc: String
    let likeCount: Int
    let commentCount: Int
    let isLike: Bool
    let backgroundColor: UIColor
}
