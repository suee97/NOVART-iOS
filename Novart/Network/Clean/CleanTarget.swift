//
//  CleanTarget.swift
//  Novart
//
//  Created by Jinwook Huh on 2/12/24.
//

import Foundation
import Alamofire

enum CleanTarget: TargetType {
    
    struct ReportRequestBody: Encodable {
        let userId: Int64
        let reportProblem: String
    }
    
    case sendReport(userId: Int64, report: ReportType)
    case requestBlock(userId: Int64)
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case .sendReport:
            return "report"
        case let .requestBlock(userId):
            return "block/\(userId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .sendReport:
            return .post
        case .requestBlock:
            return .post
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case let .sendReport(userId, report):
            return .body(ReportRequestBody(userId: userId, reportProblem: report.rawValue))
        case .requestBlock:
            return .body(nil)
        }
    }
}
