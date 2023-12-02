//
//  HomeTarget.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/23.
//

import Alamofire
import Foundation

enum HomeTarget: TargetType {
    case fetchFeed(category: String, lastId: Int64?)
    
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
        case let .fetchFeed(category, lastId):
            if let lastId {
                return .query(["category": category, "lastId": "\(lastId)"])
            } else {
                return .query(["category": category])
            }
        }
    }
}
