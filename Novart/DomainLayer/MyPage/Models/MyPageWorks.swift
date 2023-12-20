import UIKit

struct MyPageWorks: Decodable {
    let myPageWorks: [MyPageWork]
}

struct MyPageWork: Decodable {
    let id: Int64
    let name: String?
    let thumbnailImgUrl: String?
    let artistName: String?
}
