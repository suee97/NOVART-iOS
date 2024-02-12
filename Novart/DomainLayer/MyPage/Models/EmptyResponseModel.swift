import Foundation
import Alamofire

struct EmptyResponseModel: Codable, EmptyResponse {
    static func emptyValue() -> EmptyResponseModel {
        return EmptyResponseModel.init()
    }
}
