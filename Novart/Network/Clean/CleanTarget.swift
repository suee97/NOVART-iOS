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
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case .sendReport:
            return "report"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .sendReport:
            return .post
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case let .sendReport(userId, report):
            return .body(ReportRequestBody(userId: userId, reportProblem: report.rawValue))
        }
    }
}
