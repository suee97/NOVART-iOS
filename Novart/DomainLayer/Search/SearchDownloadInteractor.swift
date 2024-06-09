//
//  SearchDownloadInteractor.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/09/24.
//

import Foundation

final class SearchDownloadInteractor {
    
    func searchProducts(query: String, pageNo: Int32, category: CategoryType) async throws -> ProductSearchResponse {
        let response = try await APIClient.searchProduct(query: query, pageNo: pageNo, category: category.rawValue)
        return response
    }
    
    func searchArtists(query: String, pageNo: Int32, category: CategoryType) async throws -> ArtistSearchResponse {
        let response = try await APIClient.searchArtist(query: query, pageNo: pageNo, category: category.rawValue)
        return response
    }
    
    func getRecentSearch() async throws -> [String] {
        guard let user = Authentication.shared.user else { return [] }
        return try await APIClient.getRecentSearch()
    }
    
    func deleteRecentQuery(query: String) async throws {
        try await APIClient.deleteRecentQuery(query: query)
    }
    
    func deleteAllRecentQuery() async throws {
        try await APIClient.deleteAllRecentQuery()
    }
}
