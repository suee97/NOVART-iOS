import Foundation

struct FetchRecommendInterestsUseCase {
    let repository: MyPageRepositoryInterface
    
    func execute() async throws -> [ProductModel] {
        return try await repository.fetchRecommendInterests()
    }
}
