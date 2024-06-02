import Foundation

struct ExhibitionInfoModel: Decodable {
    let id: Int64
    var name: String? = ""
    var englishName: String? = ""
    var backgroundColor: String? = ""
    var posterImageUrl: String?
    var category: String? = ""
    var description: String? = ""
    var artCount: String? = ""
    var estimationDuration: String? = ""
    var artists: [ExhibitionParticipantModelTmp]? = []
}


// TODO: - ExhibitionDetail 수정할 때 모델 통합 예정
struct ExhibitionParticipantModelTmp: Decodable {
    let id: Int64
    let profileImageUrl: String?
    let nickname: String?
    let job: String?
    let email: String?
    let openChatUrl: String?
}
