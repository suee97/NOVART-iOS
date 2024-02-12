import Foundation
import Alamofire

final class MyPageDownloadInteractor {
    func fetchMyPageInterests(userId: Int64) async throws -> [ProductModel] {
        try await APIClient.fetchMyPageInterests(userId: userId)
    }
    
    func fetchMyPageFollowings(userId: Int64) async throws -> [ArtistModel] {
        try await APIClient.fetchMyPageFollowings(userId: userId)
    }
    
    func fetchMyPageWorks(userId: Int64) async throws -> [MyPageWork] {
        try await APIClient.fetchMyPageWorks(userId: userId)
    }
    
    func fetchMyPageExhibitions(userId: Int64) async throws -> [MyPageExhibition] {
        try await APIClient.fetchMyPageExhibitions(userId: userId)
    }
    
    func fetchRecommendInterests() async throws -> [ProductModel] {
        try await APIClient.fetchRecommendInterests()
    }
    
    func fetchRecommendFollowings() async throws -> [ArtistModel] {
        try await APIClient.fetchRecommendFollowings()
    }
    
    func fetchMyPageUserInfo(userId: Int64) async throws -> PlainUser {
        try await APIClient.fetchMyPageUserInfo(userId: userId)
    }
    
    func follow(userId: Int64) async throws -> EmptyResponseModel {
        try await APIClient.follow(userId: userId)
    }
    
    func unFollow(userId: Int64) async throws -> EmptyResponseModel {
        try await APIClient.unFollow(userId: userId)
    }
    
    func checkDuplicateNickname(nickname: String) async throws -> Bool {
        try await APIClient.checkDuplicateNickname(nickname: nickname)
    }
    
    func requestPresignedUrl(filename: String, category: String) async throws -> PresignedUrlModel {
        try await APIClient.requestPresignedUrl(filename: filename, category: category)
    }
    
    func profileEdit(profileEditRequestBodyModel: ProfileEditRequestBodyModel) async throws -> ProfileEditRequestBodyModel {
        try await APIClient.profileEdit(profileEditRequestBodyModel: profileEditRequestBodyModel)
    }
    
    func getUser() async throws -> PlainUser {
        try await APIClient.getUser()
    }
}
