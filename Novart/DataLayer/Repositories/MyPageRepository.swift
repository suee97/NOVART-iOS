import Foundation

struct MyPageRepository: MyPageRepositoryInterface {
    func fetchNotificationCheckStatus() async throws -> NotificationCheckStatus {
        return try await APIClient.fetchNotificationCheckStatus()
    }
}
