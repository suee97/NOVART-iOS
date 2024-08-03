//
//  LikeProductUseCase.swift
//  Plain
//
//  Created by Jinwook Huh on 8/3/24.
//

import Foundation

struct LikeProductUseCase {
    
    let repository: HomeRepositoryInterface
    
    func execute(productID: Int64) async throws {
        try await repository.likeProduct(productID: productID)
    }
}
