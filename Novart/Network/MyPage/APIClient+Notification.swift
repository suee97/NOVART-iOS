import Alamofire
import Foundation

extension APIClient {
    static func fetchNotifications(notificationId: Int64) async throws -> [MyPageNotificationResponseModel] {
        try await APIClient.request(target: NotificationTarget.fetchNotifications(id: notificationId), type: [MyPageNotificationResponseModel].self)
    }
}
