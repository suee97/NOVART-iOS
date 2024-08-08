//
//  ProductInteractor.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/02/08.
//

import Foundation

final class ProductInteractor {
    func likeProduct(id: Int64) async throws {
        _ = try await APIClient.likeProduct(id: id)
    }
    
    func cancelLikeProduct(id: Int64) async throws {
        _ = try await APIClient.cancelLikeProduct(id: id)
    }
    
    func deleteProduct(id: Int64) async throws {
        _ = try await APIClient.deleteProduct(id: id)
    }
}
