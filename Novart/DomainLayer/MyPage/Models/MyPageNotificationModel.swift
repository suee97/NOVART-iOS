import UIKit

struct NotificationModel: Decodable {
    let id: Int64
    let type: NotificationType
    var status: NotificationStatus
    let imageUrl: String?
    let senderId: Int64?
    let artId: Int64?
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

struct TestModel: Decodable {
    let id: Int64
}

extension NotificationModel {
    init(from dictionary: [AnyHashable: Any]) throws {
        
        guard let idString = dictionary["id"] as? String,
              let id = Int64(idString),
              let typeString = dictionary["type"] as? String,
              let type = NotificationType(rawValue: typeString.uppercased()),
              let statusString = dictionary["status"] as? String,
              let status = NotificationStatus(rawValue: statusString.uppercased()),
              let message = dictionary["message"] as? String,
              let createdAt = dictionary["createdAt"] as? String,
              let senderId = dictionary["senderId"] as? String,
              let artId = dictionary["artId"] as? String else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Required fields are missing or have incorrect types"))
        }

        self.id = id
        self.type = type
        self.status = status
        self.imageUrl = nil
        self.senderId = Int64(senderId)
        self.artId = Int64(artId)
        self.message = message
        self.createdAt = createdAt
    }
}
