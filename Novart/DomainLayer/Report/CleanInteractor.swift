//
//  CleanInteractor.swift
//  Novart
//
//  Created by Jinwook Huh on 2/12/24.
//

import Foundation

final class CleanInteractor {
    func sendReport(id: Int64, reportType: ReportType) async throws {
        switch reportType {
        case let .user(report):
            _ = try await APIClient.sendUserReport(userId: id, report: report)

        case let .product(report):
            _ = try await APIClient.sendProductReport(productId: id, report: report)
        }
    }
    
    func makeBlockRequest(userId: Int64) async throws {
        _ = try await APIClient.makeBlockRequest(userId: userId)
    }
}
