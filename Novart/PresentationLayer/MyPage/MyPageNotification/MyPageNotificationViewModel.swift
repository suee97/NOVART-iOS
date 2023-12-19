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
        var notificationTmp = [MyPageNotificationModel]()
        
        for i in 0...10 {
            notificationTmp.append(MyPageNotificationModel(id: i, type: "FOLLOW", status: "UNREAD", imgUrl: "https://t3.ftcdn.net/jpg/02/30/40/74/240_F_230407433_uF2iM6tUs1Sge24999FWdo241t8FMBi7.jpg", senderId: 0, artId: 0, message: "양용수님이 작가님의 ‘몰입북’ 작품에 댓글을 달았어요 ✏", createdAt: "2023-12-18T05:24:07.241Z"))
            notificationTmp.append(MyPageNotificationModel(id: i, type: "FOLLOW", status: "READ", imgUrl: "https://t3.ftcdn.net/jpg/02/30/40/74/240_F_230407433_uF2iM6tUs1Sge24999FWdo241t8FMBi7.jpg", senderId: 0, artId: 0, message: "Bang Tae Rim님이 작가님의 ‘FILLING CABINET’ 작품을 관심에 추가했어요 👍", createdAt: "2023-12-18T16:19:07.241Z"))
            notificationTmp.append(MyPageNotificationModel(id: i, type: "FOLLOW", status: "READ", imgUrl: "https://t3.ftcdn.net/jpg/02/30/40/74/240_F_230407433_uF2iM6tUs1Sge24999FWdo241t8FMBi7.jpg", senderId: 0, artId: 0, message: "Bang Tae Rim님이 작가님을 팔로우해요 👋", createdAt: "2023-06-18T15:24:07.241Z"))
            notificationTmp.append(MyPageNotificationModel(id: i, type: "FOLLOW", status: "UNREAD", imgUrl: "https://t3.ftcdn.net/jpg/02/30/40/74/240_F_230407433_uF2iM6tUs1Sge24999FWdo241t8FMBi7.jpg", senderId: 0, artId: 0, message: "PLAIN에 오신 것을 환영해요 🎉", createdAt: "2021-06-18T15:24:07.241Z"))
        }
        
        notifications = notificationTmp
    }
    
    @MainActor
    func showMain() {
        coordinator?.navigate(to: .MyPageMain)
    }
}
