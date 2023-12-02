import UIKit

struct Exhibition: Decodable {
    let id: Int
    let posterImageUrl: String
    let description: String
    let likesCount: Int
    let commentCount: Int
    let liked: Bool
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
