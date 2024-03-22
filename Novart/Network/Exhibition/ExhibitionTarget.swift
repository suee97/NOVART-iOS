import Alamofire
import Foundation

enum ExhibitionTarget: TargetType {
    case fetchExhibitions
    case fetchExhibitionDetail(id: Int64)
    case fetchArtistExhibition(artistId: Int64)
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchExhibitions:
            return "exhibitions"
        case let .fetchExhibitionDetail(id):
            return "exhibitions/\(id)"
        case let .fetchArtistExhibition(artistId):
            return "users/\(artistId)/exhibitions"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchExhibitions, .fetchExhibitionDetail, .fetchArtistExhibition:
            return .get
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .fetchExhibitions, .fetchExhibitionDetail, .fetchArtistExhibition:
            return .query(nil)
        }
    }
}
