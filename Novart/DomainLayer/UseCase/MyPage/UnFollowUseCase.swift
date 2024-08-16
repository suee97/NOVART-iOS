import Foundation

struct UnFollowUseCase {
    let repository: MyPageRepositoryInterface
    
    func execute(userId: Int64) async throws -> EmptyResponseModel {
        return try await repository.unFollow(userId: userId)
    }
}
