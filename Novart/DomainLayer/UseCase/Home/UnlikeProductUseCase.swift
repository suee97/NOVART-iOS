//
//  UnlikeProductUseCase.swift
//  Plain
//
//  Created by Jinwook Huh on 8/3/24.
//

import Foundation

struct UnlikeProductUseCase {
    
    let repository: HomeRepositoryInterface
    
    func execute(productID: Int64) async throws {
        try await repository.unlikeProduct(productID: productID)
    }
}
