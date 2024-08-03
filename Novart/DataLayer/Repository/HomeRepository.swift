//
//  HomeRepository.swift
//  Plain
//
//  Created by Jinwook Huh on 8/3/24.
//

import Foundation

struct HomeRepository: HomeRepositoryInterface {
    func fetchProducts(category: CategoryType, lastProductID: Int64?) async throws -> [FeedItem] {
        try await APIClient.fetchFeed(category: category, lastId: lastProductID)
    }
    
    func likeProduct(productID: Int64?) async throws {
        
    }
    
    func unlikeProduct(productID: Int64?) async throws {
        
    }
    
    
}
