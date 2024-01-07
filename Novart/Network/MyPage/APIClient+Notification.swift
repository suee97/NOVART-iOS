import Alamofire
import Foundation

extension APIClient {
    static func fetchNotifications(notificationId: Int64) async throws -> [MyPageNotificationResponseModel] {
        try await APIClient.request(target: NotificationTarget.fetchNotifications(id: notificationId), type: [MyPageNotificationResponseModel].self)
    }
    
    static func putNotificationReadStatus(notificationId: Int64) async throws {
        try await APIClient.request(target: NotificationTarget.putNotificationReadStatus(id: notificationId), type: MyPagePutNotificationReadStatusResponseModel.self)
    }
}
