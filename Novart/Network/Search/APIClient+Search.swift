//
//  APIClient+Search.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/15.
//

import Foundation
import Alamofire

extension APIClient {
    static func searchProduct(query: String, pageNo: Int32, category: String) async throws -> ProductSearchResponse {
        try await APIClient.request(target: SearchTarget.searchProduct(query: query, pageNo: pageNo, category: category), type: ProductSearchResponse.self)
    }
    
    static func searchArtist(query: String, pageNo: Int32, category: String) async throws -> ArtistSearchResponse {
        try await APIClient.request(target: SearchTarget.searchArtist(query: query, pageNo: pageNo, category: category), type: ArtistSearchResponse.self)
    }
    
    static func getRecentSearch() async throws -> [String] {
        try await APIClient.request(target: SearchTarget.recentSearch, type: [String].self)
    }
    
    static func deleteRecentQuery(query: String) async throws -> EmptyResponseModel {
        try await APIClient.request(target: SearchTarget.deleteRecentQuery(query: query), type: EmptyResponseModel.self)
    }
    
    static func deleteAllRecentQuery() async throws -> EmptyResponseModel {
        try await APIClient.request(target: SearchTarget.deleteAllRecentQuery, type: EmptyResponseModel.self)
    }
}
