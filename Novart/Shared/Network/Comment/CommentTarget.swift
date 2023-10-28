//
//  CommentTarget.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/28.
//

import Foundation
import Alamofire

enum CommentTarget: TargetType {
    case getComments(id: Int64)
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case let .getComments(id):
            return "arts/\(id)/comments"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getComments:
            return .get
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getComments:
            return .query(nil)
        }
    }
}
