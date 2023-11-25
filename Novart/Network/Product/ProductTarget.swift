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
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case let .productDetail(id):
            return "arts/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .productDetail:
            return .get
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .productDetail:
            return .query(nil)
        }
    }
}
