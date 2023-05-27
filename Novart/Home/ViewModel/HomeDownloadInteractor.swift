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
        return response.dataList
    }
    
    func fetchPopularItems() -> [PopularProductItemModel] {
        
        return []
    }
    
    func fetchRecentItems() -> [RecentProductItemModel] {
        
        return []
    }
    
    func fetchArtistIntroItems() -> [ArtistIntroItemModel] {
        
        return []
    }
}
