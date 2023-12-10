import UIKit
import Combine

final class MyPageNotificationViewModel {
    private weak var coordinator: MyPageCoordinator?
    @Published var notifications = [MyPageNotificationModel]()
    
    init(coordinator: MyPageCoordinator) {
        self.coordinator = coordinator
    }
    
    func fetchNotifications() {
        // 임시
        notifications = [
            MyPageNotificationModel(imageUrl: "https://t3.ftcdn.net/jpg/02/30/40/74/240_F_230407433_uF2iM6tUs1Sge24999FWdo241t8FMBi7.jpg", body: "한 줄 텍스트 입니다.", time: "1시간 전"),
            MyPageNotificationModel(imageUrl: "https://t3.ftcdn.net/jpg/02/30/40/74/240_F_230407433_uF2iM6tUs1Sge24999FWdo241t8FMBi7.jpg", body: "한 줄 텍스트 입니다.", time: "1분 전"),
            MyPageNotificationModel(imageUrl: "https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg", body: "한 줄 텍스트 입니다.", time: "1주 전"),
            MyPageNotificationModel(imageUrl: "https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg", body: "두줄 텍스트 두줄 텍스트 두줄 텍스트 두줄 텍스트 두줄 텍스트", time: "1년 전"),
            MyPageNotificationModel(imageUrl: "https://cdn.punchng.com/wp-content/uploads/2023/08/28143008/Yamine-Lamal.jpg", body: "세줄 텍스트 세줄 텍스트 세줄 텍스트 세줄 텍스트 세줄 텍스트 세줄 텍스트 세줄 텍스트", time: "1시간 전"),
            MyPageNotificationModel(imageUrl: "https://cdn.punchng.com/wp-content/uploads/2023/08/28143008/Yamine-Lamal.jpg", body: "Bang Tae Rim님이 작가님을 팔로우해요 👋", time: "1시간 전"),
            MyPageNotificationModel(imageUrl: "https://t3.ftcdn.net/jpg/02/30/40/74/240_F_230407433_uF2iM6tUs1Sge24999FWdo241t8FMBi7.jpg", body: "Bang Tae Rim님이 작가님의 ‘FILLING CABINET’ 작품을 관심에 추가했어요 👍", time: "1시간 전"),
            MyPageNotificationModel(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a0/Pierre-Person.jpg/800px-Pierre-Person.jpg", body: "양용수님이 작가님의 ‘몰입북’ 작품에 댓글을달았어요 ✏ ", time: "1시간 전"),
            MyPageNotificationModel(imageUrl: "https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg", body: "Bang Tae Rim님이 ‘작품제목’을 등록했어요", time: "1시간 전"),
            MyPageNotificationModel(imageUrl: "https://t4.ftcdn.net/jpg/03/83/25/83/240_F_383258331_D8imaEMl8Q3lf7EKU2Pi78Cn0R7KkW9o.jpg", body: "PLAIN에 오신 것을 환영해요 🎉", time: "1시간 전"),
        ]
    }
    
    @MainActor
    func showMain() {
        coordinator?.navigate(to: .MyPageMain)
    }
}
