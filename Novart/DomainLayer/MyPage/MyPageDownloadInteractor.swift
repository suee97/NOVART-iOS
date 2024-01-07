import Foundation

final class MyPageDownloadInteractor {
    func fetchUserInfo() async throws -> PlainUser {
        try await APIClient.getUser()
    }
}
