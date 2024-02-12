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
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case let .productDetail(id):
            return "arts/\(id)"
        case .uploadProduct:
            return "arts"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .productDetail:
            return .get
        case .uploadProduct:
            return .post
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .productDetail:
            return .query(nil)
            
        case let .uploadProduct(product):
            return .body(product)
        }
    }
}
