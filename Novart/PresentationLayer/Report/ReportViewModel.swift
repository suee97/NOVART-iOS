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
    let cleanInteractor: CleanInteractor = .init()
    
    let userId: Int64
    
    var reportButtonEnableSubject: CurrentValueSubject<Bool, Never> = .init(false)
    
    var reportProblems: [ReportType] = [] {
        didSet {
            validateReportButton()
        }
    }
    
    init(userId: Int64, coordinator: ReportCoordinator?) {
        self.userId = userId
        self.coordinator = coordinator
    }
}

// MARK: - Report
extension ReportViewModel {
    private func validateReportButton() {
        reportButtonEnableSubject.send(!reportProblems.isEmpty)
    }
    
    func addReport(type: ReportType) {
        if !reportProblems.contains(type) {
            reportProblems.append(type)
        }
    }
    
    func removeReport(type: ReportType) {
        if reportProblems.contains(type),
           let idx = reportProblems.firstIndex(where: { $0.rawValue == type.rawValue }) {
            reportProblems.remove(at: idx)
        }
    }
}

// MARK: - Network
extension ReportViewModel {
    func sendReportRequest() {
        Task {
            do {
                if !reportProblems.isEmpty {
                    try await cleanInteractor.sendReport(userId: userId, reportType: reportProblems.first ?? .hateSpeech)
                    print("success!!!!!!!!!")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
