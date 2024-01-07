import Foundation

final class NotificationDownloadInteractor {
    func fetchNotifications(notificationId: Int64) async throws -> [MyPageNotificationResponseModel] {
        try await APIClient.fetchNotifications(notificationId: notificationId)
    }
    
    func putNotificationReadStatus(notificationId: Int64) async throws {
        try await APIClient.putNotificationReadStatus(notificationId: notificationId)
    }
}
