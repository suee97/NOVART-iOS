import Alamofire
import Foundation

extension APIClient {
    static func fetchMyPageInterests(userId: Int64) async throws -> [ProductModel] {
        try await APIClient.request(target: MyPageTarget.fetchMyPageInterests(userId: userId), type: [ProductModel].self)
    }
    
    static func fetchMyPageFollowings(userId: Int64) async throws -> [ArtistModel] {
        try await APIClient.request(target: MyPageTarget.fetchMyPageFollowings(userId: userId), type: [ArtistModel].self)
    }
    
    static func fetchMyPageWorks(userId: Int64) async throws -> [MyPageWork] {
        try await APIClient.request(target: MyPageTarget.fetchMyPageWorks(userId: userId), type: [MyPageWork].self)
    }
    
    static func fetchMyPageExhibitions(userId: Int64) async throws -> [MyPageExhibition] {
        try await APIClient.request(target: MyPageTarget.fetchMyPageExhibitions(userId: userId), type: [MyPageExhibition].self)
    }
    
    static func fetchRecommendInterests() async throws -> [ProductModel] {
        try await APIClient.request(target: MyPageTarget.fetchRecommenInterests, type: [ProductModel].self)
    }
    
    static func fetchRecommendFollowings() async throws -> [ArtistModel] {
        try await APIClient.request(target: MyPageTarget.fetchRecommenFollowings, type: [ArtistModel].self)
    }
    
    static func fetchMyPageUserInfo(userId: Int64) async throws -> PlainUser {
        try await APIClient.request(target: MyPageTarget.fetchMyPageUserInfo(userId: userId), type: PlainUser.self)
    }
    
    static func follow(userId: Int64) async throws -> EmptyResponseModel {
        try await APIClient.request(target: MyPageTarget.follow(userId: userId), type: EmptyResponseModel.self)
    }
    
    static func unFollow(userId: Int64) async throws -> EmptyResponseModel {
        try await APIClient.request(target: MyPageTarget.unFollow(userId: userId), type: EmptyResponseModel.self)
    }
    
    static func checkDuplicateNickname(nickname: String) async throws -> Bool {
        try await APIClient.request(target: MyPageTarget.checkDuplicateNickname(nickname: nickname), type: Bool.self)
    }
    
    static func requestPresignedUrl(filename: String, category: String) async throws -> PresignedUrlModel {
        try await APIClient.request(target: MyPageTarget.requestPresignedUrl(filename: filename, category: category), type: PresignedUrlModel.self)
    }
    
    static func profileEdit(profileEditRequestBodyModel: ProfileEditRequestBodyModel) async throws -> ProfileEditRequestBodyModel {
        try await APIClient.request(target: MyPageTarget.profileEdit(profileEditRequestBodyModel: profileEditRequestBodyModel), type: ProfileEditRequestBodyModel.self)
    }
    
    static func fetchSetting() async throws -> MyPageSettingResponseModel {
        try await APIClient.request(target: MyPageTarget.fetchSetting, type: MyPageSettingResponseModel.self)
    }
    
    static func putSetting(setting: MyPageSettingRequestModel) async throws -> MyPageSettingResponseModel {
        try await APIClient.request(target: MyPageTarget.putSetting(setting: setting), type: MyPageSettingResponseModel.self)
    }
    
    static func deleteUser() async throws {
        try await APIClient.request(target: MyPageTarget.deleteUser, type: EmptyResponseModel.self)
    }
    
    static func fetchNotificationCheckStatus() async throws -> NotificationCheckStatus{
        try await APIClient.request(target: MyPageTarget.fetchNotificationCheckStatus, type: NotificationCheckStatus.self)
    }
    
    static func clearDeviceToken() async throws {
        try await APIClient.request(target: MyPageTarget.clearDeviceToken, type: EmptyResponseModel.self)
    }
}
