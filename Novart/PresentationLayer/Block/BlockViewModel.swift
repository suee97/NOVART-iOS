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
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
