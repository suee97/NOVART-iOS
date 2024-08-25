import Foundation

struct MyPageRepository: MyPageRepositoryInterface {
    func fetchNotificationCheckStatus() async throws -> NotificationCheckStatus {
        return try await APIClient.fetchNotificationCheckStatus()
    }
    
    func fetchAllCategoryContents(userId: Int64) async throws -> (interests: [ProductModel], followings: [ArtistModel], works: [MyPageWork], exhibitions: [ExhibitionModel]) {
        async let interestContents = APIClient.fetchMyPageInterests(userId: userId)
        async let followingContents = APIClient.fetchMyPageFollowings(userId: userId)
        async let workContents = APIClient.fetchMyPageWorks(userId: userId)
        async let exhibitionContents = APIClient.fetchMyPageExhibitions(userId: userId)
        return try await (interestContents, followingContents, workContents, exhibitionContents)
    }
    
    func fetchRecommendInterests() async throws -> [ProductModel] {
        return try await APIClient.fetchRecommendInterests()
    }
    
    func fetchRecommendFollowings() async throws -> [ArtistModel] {
        return try await APIClient.fetchRecommendFollowings()
    }
    
    func follow(userId: Int64) async throws -> EmptyResponseModel {
        return try await APIClient.follow(userId: userId)
    }
    
    func unFollow(userId: Int64) async throws -> EmptyResponseModel {
        return try await APIClient.unFollow(userId: userId)
    }
    
    func fetchUserInfo(userId: Int64) async throws -> PlainUser {
        return try await APIClient.fetchMyPageUserInfo(userId: userId)
    }
}
