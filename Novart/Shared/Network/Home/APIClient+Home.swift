//
//  APIClient+Home.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/26.
//

import Alamofire
import Foundation

extension APIClient {
    static func fetchCatalog() async throws -> NetworkResponse<[CatalogItemModel]> {
        return try await APIClient.request(target: HomeTarget.fetchCatalog, type: NetworkResponse<[CatalogItemModel]>.self)
    }
    
    static func fetchPopularItems() async throws -> NetworkResponse<[PopularProductItemModel]> {
        return try await APIClient.request(target: HomeTarget.fetchPopular, type: NetworkResponse<[PopularProductItemModel]>.self)
    }
    
    static func fetchRecentItems() async throws -> NetworkResponse<[RecentProductItemModel]> {
        return try await APIClient.request(target: HomeTarget.fetchRecent, type: NetworkResponse<[RecentProductItemModel]>.self)
    }
    
    static func fetchArtists() async throws -> NetworkResponse<[ArtistIntroItemModel]> {
        return try await APIClient.request(target: HomeTarget.fetchArtist, type: NetworkResponse<[ArtistIntroItemModel]>.self)
    }
}
