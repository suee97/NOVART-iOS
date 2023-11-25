//
//  CommentTarget.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/28.
//

import Foundation
import Alamofire

enum CommentTarget: TargetType {
    case getComments(productId: Int64)
    case writeComment(productId: Int64, content: String)
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case let .getComments(id):
            return "arts/\(id)/comments"
        case let .writeComment(id, _):
            return "arts/\(id)/comments"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getComments:
            return .get
        case .writeComment:
            return .post
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getComments:
            return .query(nil)
        case let .writeComment(_, content):
            return .body(["content": content])
        }
    }
}
