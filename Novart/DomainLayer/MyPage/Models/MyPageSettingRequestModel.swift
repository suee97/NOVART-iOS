import Foundation

struct MyPageSettingRequestModel: Codable {
    let category: SettingCategory
    let setting: Bool
}

enum SettingCategory: String, Codable {
    case activicy = "활동 알림"
    case register = "등록 알림"
    case service = "서비스 알림"
    case inquire = "문의 차단"
}
