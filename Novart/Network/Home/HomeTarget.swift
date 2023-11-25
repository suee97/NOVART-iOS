//
//  HomeTarget.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/23.
//

import Alamofire
import Foundation

enum HomeTarget: TargetType {
    case fetchFeed
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchFeed:
            return "arts"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchFeed:
            return .get
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .fetchFeed:
            return .query(nil)
        }
    }
}
