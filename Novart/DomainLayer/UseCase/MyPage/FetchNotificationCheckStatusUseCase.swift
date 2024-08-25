import Foundation

struct FetchNotificationCheckStatusUseCase {
    let repository: MyPageRepositoryInterface
    
    func execute() async throws -> NotificationCheckStatus {
        return try await repository.fetchNotificationCheckStatus()
    }
}
