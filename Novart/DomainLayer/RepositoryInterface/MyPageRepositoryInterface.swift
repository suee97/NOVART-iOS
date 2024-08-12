import Foundation

protocol MyPageRepositoryInterface {
    func fetchNotificationCheckStatus() async throws -> NotificationCheckStatus
    func fetchAllCategoryContents(userId: Int64) async throws -> (interests: [ProductModel], followings: [ArtistModel], works: [MyPageWork], exhibitions: [ExhibitionModel])
    func fetchRecommendInterests() async throws -> [ProductModel]
    func fetchRecommendFollowings() async throws -> [ArtistModel]
    func follow(userId: Int64) async throws -> EmptyResponseModel
    func unFollow(userId: Int64) async throws -> EmptyResponseModel
    func fetchUserInfo(userId: Int64) async throws -> PlainUser
}
