import Foundation
import Alamofire

enum NotificationTarget: TargetType {
    case fetchNotifications(id: Int64)
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchNotifications:
            return "notifications"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchNotifications:
            return .get
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case let .fetchNotifications(id):
            return .query(["lastId": id])
        }
    }
}
