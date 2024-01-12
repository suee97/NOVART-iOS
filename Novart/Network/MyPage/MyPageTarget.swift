import Alamofire
import Foundation

enum MyPageTarget: TargetType {
    
    // MyPage
    case fetchMyPageInterests(userId: Int64)
    case fetchMyPageFollowings(userId: Int64)
    case fetchMyPageWorks(userId: Int64)
    case fetchMyPageExhibitions(userId: Int64)
    case fetchMyPageUserInfo(userId: Int64)
    case putImageData(data: Data, presignedUrl: String)
    
    // MyPageProfileEdit
    case checkDuplicateNickname(nickname: String)
    case requestPresignedUrl(filename: String, category: String)
    case profileEdit(profileEditRequestBodyModel: ProfileEditRequestBodyModel)
    
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
        case let .fetchMyPageUserInfo(userId):
            return "users/\(userId)/info"
        case let .checkDuplicateNickname(nickname):
            return "users/check-duplicate-nickname/\(nickname)"
        case .requestPresignedUrl:
            return "s3/single"
        case .profileEdit:
            return "users/me/info"
        case .putImageData:
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchMyPageInterests, .fetchMyPageFollowings, .fetchMyPageWorks, .fetchMyPageExhibitions, .fetchMyPageUserInfo, .checkDuplicateNickname:
            return .get
        case .requestPresignedUrl:
            return .post
        case .profileEdit:
            return .put
        case .putImageData:
            return .put
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .fetchMyPageInterests, .fetchMyPageFollowings, .fetchMyPageWorks, .fetchMyPageExhibitions, .fetchMyPageUserInfo, .checkDuplicateNickname:
            return .query(nil)
        case let .requestPresignedUrl(filename, category):
            return .body(["filename": filename, "category": category])
        case let .profileEdit(profileEditRequestBodyModel):
            return .body(profileEditRequestBodyModel)
        case let .putImageData(data, _):
            return .body(data)
        }
    }
}
