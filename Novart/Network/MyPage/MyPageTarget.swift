import Alamofire
import Foundation

enum MyPageTarget: TargetType {
    
    // MyPage
    case fetchMyPageInterests(userId: Int64)
    case fetchMyPageFollowings(userId: Int64)
    case fetchMyPageWorks(userId: Int64)
    case fetchMyPageExhibitions(userId: Int64)
    case fetchRecommenInterests
    case fetchRecommenFollowings
    case fetchMyPageUserInfo(userId: Int64)
    case follow(userId: Int64)
    case unFollow(userId: Int64)
    
    // MyPageProfileEdit
    case checkDuplicateNickname(nickname: String)
    case requestPresignedUrl(filename: String, category: String)
    case putImageData(data: Data, presignedUrl: String)
    case profileEdit(profileEditRequestBodyModel: ProfileEditRequestBodyModel)
    
    // MyPageSetting
    case fetchSetting
    case putSetting(setting: MyPageSettingRequestModel)
    
    var baseURL: String {
        switch self {
        case let .putImageData(_, presignedUrl):
            return presignedUrl
        default:
            return API.baseURL
        }
    }
    
    var path: String {
        switch self {
        case let .fetchMyPageInterests(userId):
            return "users/\(userId)/likes"
        case let .fetchMyPageFollowings(userId):
            return "users/\(userId)/follow"
        case let .fetchMyPageWorks(userId):
            return "users/\(userId)/arts"
        case let .fetchMyPageExhibitions(userId):
            return "users/\(userId)/exhibitions"
        case .fetchRecommenInterests:
            return "users/me/likes/recommendation"
        case .fetchRecommenFollowings:
            return "users/me/follow/recommendation"
        case let .fetchMyPageUserInfo(userId):
            return "users/\(userId)/info"
        case let .follow(userId):
            return "follow/\(userId)"
        case let .unFollow(userId):
            return "follow/\(userId)"
        case let .checkDuplicateNickname(nickname):
            return "users/check-duplicate-nickname/\(nickname)"
        case .requestPresignedUrl:
            return "s3/single"
        case .profileEdit:
            return "users/me/info"
        case .putImageData:
            return ""
        case .fetchSetting, .putSetting:
            return "users/me/setting"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchMyPageInterests, .fetchMyPageFollowings, .fetchMyPageWorks, .fetchMyPageExhibitions, .fetchRecommenInterests, .fetchRecommenFollowings, .fetchMyPageUserInfo, .checkDuplicateNickname, .fetchSetting:
            return .get
        case .follow, .requestPresignedUrl:
            return .post
        case .profileEdit, .putSetting, .putImageData:
            return .put
        case .unFollow:
            return .delete
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .fetchMyPageInterests, .fetchMyPageFollowings, .fetchMyPageWorks, .fetchMyPageExhibitions, .fetchRecommenInterests, .fetchRecommenFollowings, .fetchMyPageUserInfo, .follow, .unFollow, .checkDuplicateNickname, .fetchSetting:
            return .query(nil)
        case let .requestPresignedUrl(filename, category):
            return .body(["filename": filename, "category": category])
        case let .profileEdit(profileEditRequestBodyModel):
            return .body(profileEditRequestBodyModel)
        case let .putImageData(data, _):
            return .body(data)
        case let .putSetting(setting):
            return .body(setting)
        }
    }
}
