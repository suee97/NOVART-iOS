import Foundation

final class NotificationDownloadInteractor {
    func fetchNotifications(notificationId: Int64) async throws -> [MyPageNotificationResponseModel] {
        let notifications = try await APIClient.fetchNotifications(notificationId: notificationId)
        return notifications
    }
}
