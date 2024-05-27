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
    
    @MainActor
    func showLogoutAlert() {
        let message = "정말 로그아웃 하시겠어요?"
        let alertController = AlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = AlertAction(title: "취소", style: .default, handler: nil)
        let logoutAction = AlertAction(title: "로그아웃", style: .destructive, handler: { [weak self] _ in
            self?.coordinator.navigate(to: .logout)
        })
        alertController.addActions([cancelAction, logoutAction])
        alertController.show()
    }
    
    @MainActor
    func showDeleteAlert() {
        let message = "정말 탈퇴하시겠어요?\n본인의 모든 정보가 사라지게 됩니다."
        let alertController = AlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = AlertAction(title: "취소", style: .default, handler: nil)
        let deleteUserAction = AlertAction(title: "탈퇴하기", style: .destructive, handler: { [weak self] _ in
//            self?.coordinator.navigate(to: )
        })
        alertController.addActions([cancelAction, deleteUserAction])
        alertController.show()
    }
}
