//
//  DiscoverTarget.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/28.
//

import Alamofire
import Foundation

enum DiscoverTarget: TargetType {
    case fetchProduct(parameters: Encodable?)
    case fetchProductDetail(id: String)
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchProduct:
            return "product"
        case .fetchProductDetail(id: let id):
            return "product/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchProduct, .fetchProductDetail:
            return .get
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .fetchProduct(let parameters):
            return .query(parameters)
        case .fetchProductDetail:
            return .query(nil)
        }
    }
}
