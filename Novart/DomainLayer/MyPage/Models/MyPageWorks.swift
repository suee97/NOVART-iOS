import UIKit

struct MyPageWorkWithImage {
    let id: Int
    let name: String
    let thumbnailImg: UIImage
    let artistName: String
}

struct MyPageWorks: Decodable {
    let myPageWorks: [MyPageWork]
}

struct MyPageWork: Decodable {
    let id: Int
    let name: String
    let thumbnailImgUrl: String
    let artistName: String
}
