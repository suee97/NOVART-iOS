import UIKit

struct MyPageInterestWithImage {
    let id: Int
    let name: String
    let thumbnailImg: UIImage
    let artistName: String
}

struct MyPageInterests: Decodable {
    let myPageInterests: [MyPageInterest]
}

struct MyPageInterest: Decodable {
    let id: Int
    let name: String
    let thumbnailImgUrl: String
    let artistName: String
}
