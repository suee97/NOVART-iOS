//
//  ReportViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2/12/24.
//

import Foundation
import Combine

final class ReportViewModel {
    private weak var coordinator: ReportCoordinator?
    
    var reportButtonEnableSubject: CurrentValueSubject<Bool, Never> = .init(false)
    
    var reportProblems: [ReportType] = [] {
        didSet {
            
        }
    }
    
    init(coordinator: ReportCoordinator?) {
        self.coordinator = coordinator
    }
}

// MARK: - Validation
private extension ReportViewModel {
    func validateReportButton() {
        
    }
}
