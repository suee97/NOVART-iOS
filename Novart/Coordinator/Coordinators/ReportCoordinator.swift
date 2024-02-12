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
}

