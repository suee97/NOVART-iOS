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
        
        let viewController = ReportViewController()
        navigator.start(viewController)
    }
}

