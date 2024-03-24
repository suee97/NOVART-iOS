import UIKit

struct NotificationModel: Decodable {
    let id: Int64
    let type: NotificationType
    var status: NotificationStatus
    let imgUrl: String?
    let senderId: Int?
    let artId: Int?
    let message: String?
    let createdAt: String
}

enum NotificationType: String, Decodable {
    case Follow = "FOLLOW"
    case Likes = "LIKES"
    case Comment = "COMMENT"
    case Welcome = "WELCOME"
    case Register = "REGISTER"
}

enum NotificationStatus: String, Decodable {
    case Read = "READ"
    case UnRead = "UNREAD"
}
