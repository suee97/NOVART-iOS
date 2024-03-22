import UIKit
import Combine

final class MyPageNotificationViewModel {
    private weak var coordinator: MyPageCoordinator?
    private var downloadInteractor = NotificationDownloadInteractor()
    @Published var notifications = [NotificationModel]()
    
    // ifFetched[notificationId] = notificationId를 통해 데이터를 불러온 적이 있는지를 나타내는 배열
    var isFetched: [Int64: Bool] = [:]
    
    init(coordinator: MyPageCoordinator) {
        self.coordinator = coordinator
    }
    
    func initNotifications() {
        notifications.removeAll()
        isFetched.removeAll()
    }
    
    @MainActor
    func showMain() {
        coordinator?.navigate(to: .MyPageMain)
    }
}

extension MyPageNotificationViewModel {
    
    @MainActor
    func fetchNotifications(notificationId: Int64) {
        isFetched[notificationId] = true
        
        Task {
            do {
                let items = try await downloadInteractor.fetchNotifications(notificationId: notificationId)
                notifications.append(contentsOf: items)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func putNotificationReadStatus(notificationId: Int64) {
        Task {
            do {
                try await downloadInteractor.putNotificationReadStatus(notificationId: notificationId)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
