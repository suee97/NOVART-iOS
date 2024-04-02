import UIKit
import Combine

final class MyPageNotificationViewModel {
    private weak var coordinator: MyPageCoordinator?
    private var downloadInteractor = NotificationDownloadInteractor()
    @Published var notifications = [NotificationModel]()
    
    var fetchedPages = [Int64]()
    var isFetching = false
    
    init(coordinator: MyPageCoordinator) {
        self.coordinator = coordinator
    }
}

extension MyPageNotificationViewModel {
    
    func fetchNotifications(notificationId: Int64) {
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
    
    func putNotificationReadStatus(notificationId: Int64) {
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
    
}


// MARK: - Navigation
extension MyPageNotificationViewModel {
    
    @MainActor
    func showMain() {
        coordinator?.navigate(to: .MyPageMain)
    }
    
    @MainActor
    func didTapNotification(at indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        NotificationNavigationHandler(coordinator: coordinator).execute(notification: notification)
    }
    
}
