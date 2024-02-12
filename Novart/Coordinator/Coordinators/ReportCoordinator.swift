//
//  ReportCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2/12/24.
//

import UIKit

final class ReportCoordinator: BaseStackCoordinator<ReportStep> {
    
    override func start() {
        super.start()
        
        let viewModel = ReportViewModel(coordinator: self)
        let viewController = ReportViewController(viewModel: viewModel)
        navigator.start(viewController)
    }
}

