//
//  ProductTarget.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/22.
//

import Foundation
import Alamofire

enum ProductTarget: TargetType {
    case productDetail(id: Int64)
    case uploadProduct(product: ProductUploadRequestModel)
    case updateProduct(product: ProductUploadRequestModel, id: Int64)
    case like(id: Int64)
    case cancelLike(id: Int64)
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case let .productDetail(id):
            return "arts/\(id)"
        case .uploadProduct:
            return "arts"
        case let .updateProduct(_, id):
            return "arts/\(id)"
        case let .like(id):
            return "likes/\(id)"
        case let .cancelLike(id):
            return "likes/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .productDetail:
            return .get
        case .uploadProduct:
            return .post
        case .updateProduct:
            return .put
        case .like:
            return .post
        case .cancelLike:
            return .delete
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .productDetail:
            return .query(nil)
        case let .uploadProduct(product):
            return .body(product)
        case let .updateProduct(product, _):
            return .body(product)
        case .like:
            return .body(nil)
        case .cancelLike:
            return .body(nil)
        }
    }
}
