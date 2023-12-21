import Foundation
import Alamofire

enum NotificationTarget: TargetType {
    case fetchNotifications(id: Int64)
    case putNotificationReadStatus(id: Int64)
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchNotifications:
            return "notifications"
        case let .putNotificationReadStatus(id):
            return "notifications/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchNotifications:
            return .get
        case .putNotificationReadStatus:
            return .put
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case let .fetchNotifications(id):
            return .query(["lastId": id])
        case .putNotificationReadStatus:
            return .query(nil)
        }
    }
}
