import UIKit
import Combine

final class MyPageSettingViewModel {
    // MARK: - Properties
    private let coordinator: MyPageCoordinator
    
    init(coordinator: MyPageCoordinator) {
        self.coordinator = coordinator
    }
    
    
    // MARK: - Navigation
    @MainActor
    func showMain() {
        coordinator.navigate(to: .MyPageSetting)
    }
}
