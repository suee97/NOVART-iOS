import Foundation

struct MyPageUserInfo: Decodable {
    let id: Int64
    let nickname: String
    let profileImageUrl: String?
    let backgroundImageUrl: String?
    let tags: [String]
    let jobs: [String]
    let email: String?
    let openChatUrl: String?
}
