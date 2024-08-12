import Foundation

struct FetchRecommendFollowingsUseCase {
    let repository: MyPageRepositoryInterface
    
    func execute() async throws -> [ArtistModel] {
        return try await repository.fetchRecommendFollowings()
    }
}
