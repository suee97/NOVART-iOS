import UIKit

struct MyPageFollowingWithImage {
    let id: Int
    let name: String
    let thumbnailImg: UIImage
    let artistName: String
}

struct MyPageFollowings: Decodable {
    let myPageFollowings: [MyPageFollowing]
}

struct MyPageFollowing: Decodable {
    let id: Int
    let name: String
    let thumbnailImgUrl: String
    let artistName: String
}
