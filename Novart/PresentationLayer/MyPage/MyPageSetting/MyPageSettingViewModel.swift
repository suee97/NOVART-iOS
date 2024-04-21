import UIKit
import Combine

final class MyPageSettingViewModel {
    
    // MARK: - Properties
    private let coordinator: MyPageCoordinator
    private let downloadInteractor = MyPageDownloadInteractor()
    var user: PlainUser?
    
    @Published var activityState = false
    @Published var registerState = false
    @Published var serviceState = false
    @Published var inquireState = false
    var isLoading = false
    
    init(coordinator: MyPageCoordinator, user: PlainUser? = nil) {
        self.coordinator = coordinator
        self.user = user
    }
    
    
    // MARK: - API
    func fetchSetting() {
        Task {
            do {
                isLoading = true
                let response = try await downloadInteractor.fetchSetting()
                activityState = response.activityNotification
                registerState = response.registerNotification
                serviceState = response.serviceNotification
                inquireState = response.blockRequest
            } catch {
                print(error.localizedDescription)
            }
            isLoading = false
        }
    }
    
    func putSetting(setting: MyPageSettingRequestModel) {
        guard !isLoading else { return }
        Task {
            do {
                let response = try await downloadInteractor.putSetting(setting: setting)
                switch setting.category {
                case .activicy:
                    activityState = response.activityNotification
                case .register:
                    registerState = response.registerNotification
                case .service:
                    serviceState = response.serviceNotification
                case .inquire:
                    inquireState = response.blockRequest
                }
            } catch {
                print(error.localizedDescription)
            }
        }
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
    
    @MainActor
    func showPolicy(policyType: PolicyType) {
        coordinator.navigate(to: .policy(policyType: policyType))
    }
}

extension MyPageSettingViewModel {
    @MainActor
    func didTapLogoutButton() {
        coordinator.navigate(to: .logout)
    }
}
