//
//  LoginViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/02.
//

import Foundation
import Combine


final class LoginViewModel {
    
    var isFirstLogin: PassthroughSubject<Bool, Never> = PassthroughSubject<Bool, Never>()
    var isPresentedAsModal: Bool
    
    private weak var coordinator: LoginCoordinator?
    private let interactor: LoginInteractor
    
    convenience init(
        isPresentedAsModal: Bool,
        coordinator: LoginCoordinator
    ) {
        self.init(isPresentedAsModal: isPresentedAsModal, coordinator: coordinator, interactor: LoginInteractor())
    }
    
    private init(
        isPresentedAsModal: Bool,
        coordinator: LoginCoordinator,
        interactor: LoginInteractor
    ) {
        self.isPresentedAsModal = isPresentedAsModal
        self.coordinator = coordinator
        self.interactor = interactor
    }
    
    @MainActor
    func showMainScene() {
        coordinator?.navigate(to: .main)
    }
    
    func login(with type: SignInProvider) {
        switch type {
        case .google:
            Task {
                do {
                    let accessToken = try await interactor.performGoogleSignIn()
                    let isFirst = try await interactor.login(accessToken: accessToken, provider: .google)
                    DispatchQueue.main.async {
                        DispatchQueue.main.async { [weak self] in
                            self?.isFirstLogin.send(isFirst)
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }

        case .kakao:
            Task {
                do {
                    let authToken = try await interactor.performKakaoSignIn()
                    let isFirst = try await interactor.login(accessToken: authToken.accessToken, provider: .kakao)
                    DispatchQueue.main.async { [weak self] in
                        self?.isFirstLogin.send(isFirst)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        case .apple:
            Task {
                do {
                    let identityToken = try await interactor.performAppleLogin()
                    let isFirst = try await interactor.login(accessToken: identityToken, provider: .apple)
                    DispatchQueue.main.async { [weak self] in
                        self?.isFirstLogin.send(isFirst)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    @MainActor
    func transitionToMainScene() {
        coordinator?.navigate(to: .main)
    }
    
    @MainActor
    func showPolicyAgreeViewController() {
        coordinator?.navigate(to: .policyAgree)
    }
    
    @MainActor
    func showPolicy() {
        
    }
}
