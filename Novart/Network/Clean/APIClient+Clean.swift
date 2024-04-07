//
//  APIClient+Clean.swift
//  Novart
//
//  Created by Jinwook Huh on 2/12/24.
//

import Foundation
import Alamofire

extension APIClient {
    static func sendUserReport(userId: Int64, report: UserReportType) async throws -> EmptyResponseModel {
        try await APIClient.request(target: CleanTarget.sendUserReport(userId: userId, report: report), type: EmptyResponseModel.self)
    }
    
    static func sendProductReport(productId: Int64, report: ProductReportType) async throws -> EmptyResponseModel {
        try await APIClient.request(target: CleanTarget.sendProductReport(productId: productId, report: report), type: EmptyResponseModel.self)
    }
    
    static func makeBlockRequest(userId: Int64) async throws -> EmptyResponseModel {
        try await APIClient.request(target: CleanTarget.requestBlock(userId: userId), type: EmptyResponseModel.self)
    }
}
