//
//  ReportDoneViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2/17/24.
//

import Foundation

final class ReportDoneViewModel {
    private weak var coordinator: ReportCoordinator?

    init(coordinator: ReportCoordinator?) {
        self.coordinator = coordinator
    }

    @MainActor
    func closeCoordinator() {
        coordinator?.close()
    }

}
