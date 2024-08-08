//
//  FetchProductsUseCase.swift
//  Plain
//
//  Created by Jinwook Huh on 8/3/24.
//

import Foundation

struct FetchProductsUseCase {
    let repository: HomeRepositoryInterface
    
    func execute(category: CategoryType, lastProductID: Int64?) async throws -> [FeedItem] {
        try await repository.fetchProducts(category: category, lastProductID: lastProductID)
    }
}
