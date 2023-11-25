import UIKit

struct MyPageExhibitionWithImage {
    let id: Int
    let name: String
    let thumbnailImg: UIImage
    let artistName: String
}

struct MyPageExhibitions: Decodable {
    let myPageExhibitions: [MyPageExhibition]
}

struct MyPageExhibition: Decodable {
    let id: Int
    let name: String
    let thumbnailImgUrl: String
    let artistName: String
}
