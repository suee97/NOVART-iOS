import UIKit

struct MyPageExhibitions: Decodable {
    let myPageExhibitions: [MyPageExhibition]
}

struct MyPageExhibition: Decodable {
    let id: Int64
    let name: String?
    let thumbnailImgUrl: String?
    let artistName: String?
}
