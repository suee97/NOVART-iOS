import Foundation

struct MyPageSettingResponseModel: Codable {
    var activityNotification: Bool
    var registerNotification: Bool
    var serviceNotification: Bool
    var blockRequest: Bool
}
