//
//  ReportViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2/12/24.
//

import Foundation
import Combine

enum ReportDomain {
    case user
    case product
}

final class ReportViewModel {
    private weak var coordinator: ReportCoordinator?
    let cleanInteractor: CleanInteractor = .init()
    
    let id: Int64
    let domain: ReportDomain
    
    var reportButtonEnableSubject: CurrentValueSubject<Bool, Never> = .init(false)
    var reportTypeUpdated: PassthroughSubject<ReportType?, Never> = .init()
    var reportDoneSubject: PassthroughSubject<Bool, Never> = .init()
    
    var selectedReportType: ReportType? {
        didSet {
            updateCheckUI()
            validateReportButton()
        }
    }
    
    init(id: Int64, domain: ReportDomain, coordinator: ReportCoordinator?) {
        self.id = id
        self.domain = domain
        self.coordinator = coordinator
    }
    
    @MainActor
    func showReportDoneScene() {
        coordinator?.navigate(to: .reportDone)
    }
    
    @MainActor
    func closeCoordinator() {
        coordinator?.close()
    }

}

// MARK: - Report
extension ReportViewModel {
    private func updateCheckUI() {
        reportTypeUpdated.send(selectedReportType)
    }
    
    private func validateReportButton() {
        reportButtonEnableSubject.send(selectedReportType != nil)
    }
    
    func selectReport(type: ReportType) {
        selectedReportType = type
    }
    
    func deselectReport() {
        selectedReportType = nil
    }
}

// MARK: - Network
extension ReportViewModel {
    func sendReportRequest() {
        Task {
            do {
                if let selectedReportType {
                    try await cleanInteractor.sendReport(id: id, reportType: selectedReportType)
                    reportDoneSubject.send(true)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
