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
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchProduct:
            return "product"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchProduct:
            return .get
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .fetchProduct(let parameters):
            return .query(parameters)
        }
    }
}
