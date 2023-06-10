//
//  HomeDownloadInteractor.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/26.
//

import Foundation

final class HomeDownloadInteractor {
    func fetchCatalogItems() async throws -> [CatalogItemModel]? {
        let response = try await APIClient.fetchCatalog()
        return response.data
    }
    
    func fetchPopularItems() async throws -> [PopularProductItemModel]? {
        let response = try await APIClient.fetchPopularItems()
        return response.data
    }
    
    func fetchRecentItems() async throws  -> [RecentProductItemModel]? {
        let response = try await APIClient.fetchRecentItems()
        return response.data
    }
    
    func fetchArtistIntroItems() async throws -> [ArtistIntroItemModel]? {
        let response = try await APIClient.fetchArtists()
        return response.data
    }
}
