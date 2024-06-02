import Alamofire
import Foundation

enum ExhibitionTarget: TargetType {
    case fetchExhibitions
    case fetchExhibitionInfo(id: Int64)
    case fetchExhibitionDetail(id: Int64)
    case fetchArtistExhibition(artistId: Int64)
    case like(id: Int64)
    case unlike(id: Int64)
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchExhibitions:
            return "exhibitions"
        case let .fetchExhibitionInfo(id):
            return "exhibitions/\(id)/info"
        case let .fetchExhibitionDetail(id):
            return "exhibitions/\(id)"
        case let .fetchArtistExhibition(artistId):
            return "users/\(artistId)/exhibitions"
        case let .like(id):
            return "exhibitions/\(id)/likes"
        case let .unlike(id):
            return "exhibitions/\(id)/unlike"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchExhibitions, .fetchExhibitionInfo, .fetchExhibitionDetail, .fetchArtistExhibition:
            return .get
        case .like:
            return .post
        case .unlike:
            return .delete
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .fetchExhibitions, .fetchExhibitionInfo, .fetchExhibitionDetail, .fetchArtistExhibition:
            return .query(nil)
        case .like:
            return .body(nil)
        case .unlike:
            return .body(nil)
        }
    }
}
