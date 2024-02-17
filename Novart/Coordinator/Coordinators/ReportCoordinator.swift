//
//  ReportCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2/12/24.
//

import UIKit

final class ReportCoordinator: BaseStackCoordinator<ReportStep> {
    
    @LateInit
    var userId: Int64
        
    override func start() {
        super.start()
        
        let viewModel = ReportViewModel(userId: userId, coordinator: self)
        let viewController = ReportViewController(viewModel: viewModel)
        navigator.start(viewController)
    }
    
    override func navigate(to step: ReportStep) {
        switch step {
        case .reportDone:
            showReportDoneScene()
        }
    }
}

extension ReportCoordinator {
    
    @MainActor
    private func showReportDoneScene() {
        let viewModel = ReportDoneViewModel(coordinator: self)
        let viewController = ReportDoneViewController(viewModel: viewModel)
        navigator.push(viewController, animated: true)
    }
}

