import Alamofire
import Foundation

enum ExhibitionTarget: TargetType {
    case fetchExhibitions
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchExhibitions:
            return "exhibitions"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchExhibitions:
            return .get
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .fetchExhibitions:
            return .query(nil)
        }
    }
}
