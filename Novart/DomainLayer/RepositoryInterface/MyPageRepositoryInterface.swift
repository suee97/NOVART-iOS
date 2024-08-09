import Foundation

protocol MyPageRepositoryInterface {
    func fetchNotificationCheckStatus() async throws -> NotificationCheckStatus
}
