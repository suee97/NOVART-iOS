//
//  BlockViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2/17/24.
//

import Foundation
import Combine

final class BlockViewModel {
    private weak var coordinator: BlockCoordinator?
    let cleanInteractor: CleanInteractor = .init()
    
    let user: PlainUser
    
    init(user: PlainUser, coordinator: BlockCoordinator?) {
        self.user = user
        self.coordinator = coordinator
    }

    @MainActor
    func closeCoordinator() {
        coordinator?.close()
    }
}

// MARK: - block
extension BlockViewModel {
    func makeBlockRequest() {
        Task {
            do {
//                try await cleanInteractor.makeBlockRequest(userId: user.id)
                DispatchQueue.main.async { [weak self] in
                    self?.closeCoordinator()
                    PlainSnackbar.show(message: "이 사용자를 차단했어요.", configuration: .init(imageType: .icon(.block)))
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
