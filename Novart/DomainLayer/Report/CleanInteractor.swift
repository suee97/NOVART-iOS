//
//  CleanInteractor.swift
//  Novart
//
//  Created by Jinwook Huh on 2/12/24.
//

import Foundation

final class CleanInteractor {
    func sendReport(userId: Int64, reportType: ReportType) async throws {
        _ = try await APIClient.sendReport(userId: userId, report: reportType)
    }
}
