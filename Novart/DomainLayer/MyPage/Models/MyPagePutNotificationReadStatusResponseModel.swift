import Foundation
import Alamofire

struct MyPagePutNotificationReadStatusResponseModel: Decodable, EmptyResponse {
    static func emptyValue() -> MyPagePutNotificationReadStatusResponseModel {
        return MyPagePutNotificationReadStatusResponseModel.init()
    }
}
