//
//  HomeTarget.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/23.
//

import Alamofire
import Foundation

enum HomeTarget: TargetType {
    case fetchCatalog
    case fetchPopular
    case fetchRecent
    case fetchArtist
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchCatalog:
            return "home/news"
        case .fetchPopular:
            return "home/product/favorite-summary"
        case .fetchRecent:
            return "home/product/recent-summary"
        case .fetchArtist:
            return "home/artists/summary"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchCatalog, .fetchPopular, .fetchRecent, .fetchArtist:
            return .get
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .fetchCatalog, .fetchPopular, .fetchRecent, .fetchArtist:
            return .query(nil)
        }
    }
}
