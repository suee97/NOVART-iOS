//
//  APIClient+Clean.swift
//  Novart
//
//  Created by Jinwook Huh on 2/12/24.
//

import Foundation
import Alamofire

extension APIClient {
    static func sendReport(userId: Int64, report: ReportType) async throws -> EmptyResponseModel {
        try await APIClient.request(target: CleanTarget.sendReport(userId: userId, report: report), type: EmptyResponseModel.self)
    }
}
