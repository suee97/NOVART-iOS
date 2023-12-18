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
            notificationTmp.append(MyPageNotificationModel(id: i, type: "FOLLOW", status: "UNREAD", imgUrl: "https://t3.ftcdn.net/jpg/02/30/40/74/240_F_230407433_uF2iM6tUs1Sge24999FWdo241t8FMBi7.jpg", senderId: 0, artId: 0, message: "예시 텍스트입니다.1", createdAt: "2023-12-18T05:24:07.241Z"))
            notificationTmp.append(MyPageNotificationModel(id: i, type: "FOLLOW", status: "UNREAD", imgUrl: "https://t3.ftcdn.net/jpg/02/30/40/74/240_F_230407433_uF2iM6tUs1Sge24999FWdo241t8FMBi7.jpg", senderId: 0, artId: 0, message: "예시 텍스트입니다.222222222222222222222222", createdAt: "2023-12-18T16:19:07.241Z"))
            notificationTmp.append(MyPageNotificationModel(id: i, type: "FOLLOW", status: "UNREAD", imgUrl: "https://t3.ftcdn.net/jpg/02/30/40/74/240_F_230407433_uF2iM6tUs1Sge24999FWdo241t8FMBi7.jpg", senderId: 0, artId: 0, message: "예시 텍스트입니다.333333", createdAt: "2023-06-18T15:24:07.241Z"))
            notificationTmp.append(MyPageNotificationModel(id: i, type: "FOLLOW", status: "UNREAD", imgUrl: "https://t3.ftcdn.net/jpg/02/30/40/74/240_F_230407433_uF2iM6tUs1Sge24999FWdo241t8FMBi7.jpg", senderId: 0, artId: 0, message: "예시 텍스트입니다.333333", createdAt: "2021-06-18T15:24:07.241Z"))
        }
        
        notifications = notificationTmp
    }
    
    @MainActor
    func showMain() {
        coordinator?.navigate(to: .MyPageMain)
    }
}
