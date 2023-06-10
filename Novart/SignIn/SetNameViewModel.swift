//
//  SetNameViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/07.
//

import SwiftUI
import Combine

class SetNameViewModel: ObservableObject {
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var nickname: String = AuthProperties.shared.user?.nickname ?? ""
    @Published var isAllAgree: Bool = false
    @Published var isServiceAgree: Bool = false
    @Published var isPrivacyAgree: Bool = false
    @Published var isMarketingAgree: Bool = false
    @Published var enableDone: Bool = false
    
    @Published var setNameSuccess: Bool = false
    
    let maxNicknameLength = 15

    var interactor: SignInInteractor = SignInInteractor()
        
    init() {
        setBindings()
    }
    
    private func setBindings() {
        Publishers.CombineLatest($isServiceAgree, $isPrivacyAgree)
            .map { $0 && $1 }
            .sink { [weak self] combined in
                self?.enableDone = combined }
            .store(in: &subscriptions)
    }
    
    func setNickname() {
        Task { @MainActor in
            do {
                setNameSuccess = try await interactor.setNickname(as: nickname)
            } catch {
                print(error)
                setNameSuccess = false
            }
        }
    }
}
