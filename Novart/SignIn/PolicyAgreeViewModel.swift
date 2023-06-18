//
//  PolicyAgreeViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/18.
//

import Foundation
import Combine

class PolicyAgreeViewModel: ObservableObject {
    
    private var subscriptions = Set<AnyCancellable>()
    
    private var interactor: SignupInteractor = SignupInteractor()
    
    @Published var isAllAgree: Bool = false
    @Published var isServiceAgree: Bool = false
    @Published var isPrivacyAgree: Bool = false
    @Published var isMarketingAgree: Bool = false
    @Published var enableNext: Bool = false
    @Published var isSignupSuccess: Bool = false
    
    init() {
        setBindings()
    }
    
    private func setBindings() {
        Publishers.CombineLatest($isServiceAgree, $isPrivacyAgree)
            .map { $0 && $1 }
            .sink { [weak self] combined in
                self?.enableNext = combined }
            .store(in: &subscriptions)
    }
    
    func signup() {
        Task {
            do {
                let signupSuccess = try await interactor.signup(isMarketingAgree: isMarketingAgree)
                DispatchQueue.main.async { [weak self] in
                    self?.isSignupSuccess = signupSuccess
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
