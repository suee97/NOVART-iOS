//
//  HomeTarget.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/26.
//

import Alamofire
import Foundation

enum HomeTarget: TargetType {
    case fetchCatalog
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchCatalog:
            return "home/news"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchCatalog:
            return .get
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .fetchCatalog:
            return .query(nil)
        }
    }
}
