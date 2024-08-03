//
//  HomeRepositoryInterface.swift
//  Plain
//
//  Created by Jinwook Huh on 8/3/24.
//

import Foundation

protocol HomeRepositoryInterface {
    func fetchProducts(category: CategoryType, lastProductID: Int64?) async throws -> [FeedItem]
    func likeProduct(productID: Int64?) async throws
    func unlikeProduct(productID: Int64?) async throws
}
