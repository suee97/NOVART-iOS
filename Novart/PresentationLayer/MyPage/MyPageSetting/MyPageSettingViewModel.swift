import UIKit
import Combine

final class MyPageSettingViewModel {
    // MARK: - Properties
    private let coordinator: MyPageCoordinator
    var user: PlainUser?
    
    init(coordinator: MyPageCoordinator, user: PlainUser? = nil) {
        self.coordinator = coordinator
        self.user = user
    }
    
    
    // MARK: - Navigation
    @MainActor
    func showMain() {
        coordinator.navigate(to: .MyPageMain)
    }
    
    @MainActor
    func showLoginModal() {
        coordinator.navigate(to: .LoginModal)
    }
}
