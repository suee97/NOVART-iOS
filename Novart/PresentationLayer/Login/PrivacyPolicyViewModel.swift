//
//  PrivacyPolicyViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/22.
//

import Foundation
import Combine

final class PrivacyPolicyViewModel {
    private weak var coordinator: LoginCoordinator?
    private let signUpInteractor: SignUpInteractor = .init()
    
    @Published var allSelected: Bool = false
    @Published var servicePolicySelected: Bool = false
    @Published var privacyPolicySelected: Bool = false
    @Published var marketingPolicySelected: Bool = false
    @Published var isNextButtonEnabled: Bool = false
    var signUpUser: PassthroughSubject<PlainUser, Never> = .init()
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
        setBindings()
    }
    
    @MainActor
    func transitionToMainScene() {
        coordinator?.navigate(to: .main)
    }
    
    private func setBindings() {
        Publishers.CombineLatest($servicePolicySelected, $privacyPolicySelected)
            .sink { [weak self] isServiceSelected, isPrivacySelected in
                guard let self else { return }
                self.isNextButtonEnabled = ( isServiceSelected && isPrivacySelected )
            }
            .store(in: &cancellables)
        
        signUpUser
            .receive(on: DispatchQueue.main)
            .sink { _ in
                Task { [weak self] in
                    await self?.transitionToMainScene()
                }
            }
            .store(in: &cancellables)
    }
}

extension PrivacyPolicyViewModel {
    func signUp() {
        Task {
            do {
                let user = try await signUpInteractor.signUp(marketingPolicySelected: marketingPolicySelected)
                signUpUser.send(user)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
