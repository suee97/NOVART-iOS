//
//  CommentTarget.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/28.
//

import Foundation
import Alamofire

enum CommentTarget: TargetType {
    case getProductComments(productId: Int64)
    case writeProductComment(productId: Int64, content: String)
    case getExhibitionComments(exhibitionId: Int64)
    case writeExhibitionComment(exhibitionId: Int64, content: String)
    case deleteProductComment(commentId: Int64)
    case deleteExhibitionComment(commentId: Int64)
    case editProductComment(commentId: Int64, content: String)
    case editExhibitionComment(commentId: Int64, content: String)
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case let .getProductComments(id):
            return "arts/\(id)/comments"
        case let .writeProductComment(id, _):
            return "arts/\(id)/comments"
        case let .getExhibitionComments(id):
            return "exhibitions/\(id)/comments"
        case let .writeExhibitionComment(id, _):
            return "exhibitions/\(id)/comments"
        case let .deleteProductComment(commentId):
            return "comments/\(commentId)"
        case let .deleteExhibitionComment(commentId):
            return "exhibitions/comments/\(commentId)"
        case let .editProductComment(commentId, _):
            return "comments/\(commentId)"
        case let .editExhibitionComment(commentId, _):
            return "exhibitions/comments/\(commentId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getProductComments, .getExhibitionComments:
            return .get
        case .writeProductComment, .writeExhibitionComment:
            return .post
        case .deleteProductComment, .deleteExhibitionComment:
            return .delete
        case .editProductComment, .editExhibitionComment:
            return .put
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getProductComments, .getExhibitionComments:
            return .query(nil)
        case let .writeProductComment(_, content):
            return .body(["content": content])
        case let .writeExhibitionComment(_, content):
            return .body(["content": content])
        case .deleteProductComment, .deleteExhibitionComment:
            return .query(nil)
        case let .editProductComment(_, content):
            return .body(["content": content])
        case let .editExhibitionComment(_, content):
            return .body(["content": content])
        }
    }
}
