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
    case recentSearch
    case deleteRecentQuery(query: String)
    case deleteAllRecentQuery
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case .searchProduct:
            return "search/arts"
        case .searchArtist:
            return "search/artists"
        case .recentSearch:
            return "search/recent-search"
        case let .deleteRecentQuery(query):
            return "search/recent-search/\(query)"
        case .deleteAllRecentQuery:
            return "search/recent-search"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchProduct, .searchArtist, .recentSearch:
            return .get
        case .deleteAllRecentQuery, .deleteRecentQuery:
            return .delete
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case let .searchProduct(query, pageNo, category):
            return .query(["query": query, "pageNo": "\(pageNo)", "category": "\(category)"])
        case let .searchArtist(query, pageNo, category):
            return .query(["query": query, "pageNo": "\(pageNo)", "category": "\(category)"])
        case .recentSearch:
            return .query(nil)
        case .deleteRecentQuery, .deleteAllRecentQuery:
            return .query(nil)
        }
    }
}
