import UIKit

class ExhibitionModel: PlainItem, Decodable {
    let id: Int64
    let posterImageUrl: String?
    let description: String
    let likesCount: Int
    let commentCount: Int
    let liked: Bool
    
    init(id: Int64, posterImageUrl: String?, description: String, likesCount: Int, commentCount: Int, liked: Bool) {
        self.id = id
        self.posterImageUrl = posterImageUrl
        self.description = description
        self.likesCount = likesCount
        self.commentCount = commentCount
        self.liked = liked
        super.init()
    }
}

struct ProcessedExhibition: Hashable {
    let id: Int
    let imageView: UIImageView
    let description: String
    let likesCount: Int
    let commentCount: Int
    let liked: Bool
    let backgroundColor: UIColor
}
