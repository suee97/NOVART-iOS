//
//  SetNicknameViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/01.
//

import Foundation
import Combine

final class SetNicknameViewModel {
    private weak var coordinator: HomeCoordinator?
    private let userInteractor: UserInteractor = .init()
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    @Published var nickname: String = ""
    @Published var isDuplicateCheckEnabled: Bool = false
    var isValidNickname: PassthroughSubject<Bool, Never> = .init()
    
    @Published var defaultNickname: String = ""
    var maximumNicknameLength = 15
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        setBindings()
    }
    
    private func setBindings() {
        $nickname
            .sink { [weak self] nickname in
                guard let self else { return }
                self.updateDuplicateCheckEnabled(for: nickname)
            }
            .store(in: &cancellables)
    }
    
    private func updateDuplicateCheckEnabled(for nickname: String) {
        if !nickname.isEmpty && nickname != defaultNickname {
            isDuplicateCheckEnabled = true
        } else {
            isDuplicateCheckEnabled = false
        }
    }
}

extension SetNicknameViewModel {
    
    func loadDefaultNickname() {
        defaultNickname = Authentication.shared.user?.nickname ?? ""
        nickname = defaultNickname
    }
    
    func checkNicknameValidation() {
        Task {
            let isValid = try await userInteractor.checkIsValidNickname(nickname: nickname)
            isValidNickname.send(isValid)
        }
    }
}

