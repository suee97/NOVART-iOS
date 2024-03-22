import UIKit

struct MyPageNotificationResponseModel: Codable {
    let id: Int64
    let type: String?
    var status: String
    let imgUrl: String?
    let senderId: Int?
    let artId: Int?
    let message: String?
    let createdAt: String
}

struct MyPageNotificationModel {
    let id: Int64
    let type: MyPageNotificationType
    var status: MyPageNotificationStatus
    let imgUrl: String?
    let senderId: Int?
    let artId: Int?
    let message: String?
    let createdAt: String
}

enum MyPageNotificationType: String {
    case Follow = "FOLLOW"
    case Likes = "LIKES"
    case Comment = "COMMENT"
    case Welcome = "WELCOME"
    case Register = "REGISTER"
}

enum MyPageNotificationStatus: String {
    case Read = "READ"
    case UnRead = "UNREAD"
}
