import Foundation

struct FollowUseCase {
    let repository: MyPageRepositoryInterface
    
    func execute(userId: Int64) async throws -> EmptyResponseModel {
        return try await repository.follow(userId: userId)
    }
}
