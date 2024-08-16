import Foundation

struct FetchUserInfoUseCase {
    let repository: MyPageRepositoryInterface
    
    func execute(userId: Int64) async throws -> PlainUser {
        return try await repository.fetchUserInfo(userId: userId)
    }
}
