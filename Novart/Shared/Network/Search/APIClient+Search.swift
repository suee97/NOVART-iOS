//
//  APIClient+Search.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/15.
//

import Foundation
import Alamofire

extension APIClient {
    static func searchProduct(query: String, pageNo: Int32) async throws -> ProductSearchResponse {
        try await APIClient.request(target: SearchTarget.searchProduct(query: query, pageNo: pageNo), type: ProductSearchResponse.self)
    }
    
    static func searchArtist(query: String, pageNo: Int32) async throws -> ArtistSearchResponse {
        try await APIClient.request(target: SearchTarget.searchArtist(query: query, pageNo: pageNo), type: ArtistSearchResponse.self)
    }
}
