import Foundation

struct FetchAllCategoryContentsUseCase {
    let repository: MyPageRepositoryInterface
    
    func execute(userId: Int64) async throws -> (interests: [ProductModel], followings: [ArtistModel], works: [MyPageWork], exhibitions: [ExhibitionModel]) {
        return try await repository.fetchAllCategoryContents(userId: userId)
    }
}
