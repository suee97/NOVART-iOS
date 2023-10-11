import Foundation
import Combine

final class MyPageProfileEditViewModel {
    // MARK: - Properties
    private let coordinator: MyPageCoordinator
    
    init(coordinator: MyPageCoordinator) {
        self.coordinator = coordinator
    }
    
    
    // MARK: - Navigation
    @MainActor
    func showMain() {
        coordinator.navigate(to: .main)
    }
}
