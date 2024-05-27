import UIKit
import Combine

final class MyPageNotificationViewModel {
    private weak var coordinator: MyPageCoordinator?
    private var downloadInteractor = NotificationDownloadInteractor()
    @Published private(set) var notifications = [NotificationModel]()
    
    private var fetchedPages = [Int64]()
    private var isFetching = false
    
    init(coordinator: MyPageCoordinator) {
        self.coordinator = coordinator
    }
}

extension MyPageNotificationViewModel {
    
    func fetchNotifications(notificationId: Int64 = 0) {
        guard !isFetching else { return }
        Task {
            isFetching = true
            do {
                let items = try await downloadInteractor.fetchNotifications(notificationId: notificationId)
                fetchedPages.append(notificationId)
                notifications.append(contentsOf: items)
            } catch {
                print(error.localizedDescription)
            }
            isFetching = false
        }
    }
    
    private func putNotificationReadStatus(notificationId: Int64) {
        Task {
            do {
                try await downloadInteractor.putNotificationReadStatus(notificationId: notificationId)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func scrollViewDidReachBottom(cellIds: [Int64]) {
        guard let lastId = notifications.last?.id, !isFetching else { return }
        let isFetched = fetchedPages.contains(lastId)
        if !isFetched && cellIds.contains(lastId) {
            fetchNotifications(notificationId: lastId)
        }
    }
    
    func onRefresh() async {
        guard !isFetching else { return }
        isFetching = true
        do {
            try await Task.sleep(seconds: 1) // Test
            fetchedPages.removeAll()
            let items = try await downloadInteractor.fetchNotifications(notificationId: 0)
            notifications = items
        } catch {
            print(error.localizedDescription)
        }
        isFetching = false
    }
    
    func readNotification(index: Int) {
        if notifications[index].status == .UnRead {
            notifications[index].status = .Read
            putNotificationReadStatus(notificationId: notifications[index].id)
        }
    }
    
}


// MARK: - Navigation
extension MyPageNotificationViewModel {
    
    @MainActor
    func showMain() {
        coordinator?.navigate(to: .MyPageMain)
    }
    
    @MainActor
    func pushViewController(index: Int) {
        let notification = notifications[index]
        NotificationNavigationHandler(coordinator: coordinator).execute(notification: notification)
    }
    
}
