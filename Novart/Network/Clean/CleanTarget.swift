//
//  CleanTarget.swift
//  Novart
//
//  Created by Jinwook Huh on 2/12/24.
//

import Foundation
import Alamofire

enum CleanTarget: TargetType {
    
    struct UserReportRequestBody: Encodable {
        let userId: Int64
        let reportProblem: String
    }
    
    struct ProductReportRequestBody: Encodable {
        let artId: Int64
        let artReportProblem: String
    }
    
    case sendUserReport(userId: Int64, report: UserReportType)
    case sendProductReport(productId: Int64, report: ProductReportType)
    case requestBlock(userId: Int64)
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case .sendUserReport:
            return "report"
        case .sendProductReport:
            return "report/arts"
        case let .requestBlock(userId):
            return "block/\(userId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .sendUserReport, .sendProductReport:
            return .post
        case .requestBlock:
            return .post
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case let .sendUserReport(userId, report):
            return .body(UserReportRequestBody(userId: userId, reportProblem: report.rawValue))
        case let .sendProductReport(productId, report):
            return .body(ProductReportRequestBody(artId: productId, artReportProblem: report.rawValue))
        case .requestBlock:
            return .body(nil)
        }
    }
}
