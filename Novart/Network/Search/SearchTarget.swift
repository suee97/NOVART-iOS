//
//  SearchTarget.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/15.
//

import Foundation
import Alamofire

enum SearchTarget: TargetType {
    case searchProduct(query: String, pageNo: Int32, category: String)
    case searchArtist(query: String, pageNo: Int32, category: String)
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case .searchProduct:
            return "search/arts"
        case .searchArtist:
            return "search/artists"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchProduct, .searchArtist:
            return .get
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case let .searchProduct(query, pageNo, category):
            return .query(["query": query, "pageNo": "\(pageNo)", "category": "\(category)"])
        case let .searchArtist(query, pageNo, category):
            return .query(["query": query, "pageNo": "\(pageNo)", "category": "\(category)"])
        }
    }
}
