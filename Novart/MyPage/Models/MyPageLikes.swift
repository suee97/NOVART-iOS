import UIKit

struct MyPageLikeWithImage {
    let id: Int
    let name: String
    let thumbnailImg: UIImage
    let artistName: String
}

struct MyPageLikes: Decodable {
    let myPageLikes: [MyPageLike]
}

struct MyPageLike: Decodable {
    let id: Int
    let name: String
    let thumbnailImgUrl: String
    let artistName: String
}
