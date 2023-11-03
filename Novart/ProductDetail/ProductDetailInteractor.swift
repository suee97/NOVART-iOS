//
//  ProductDetailInteractor.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/22.
//

import Foundation

final class ProductDetailInteractor {
    func fetchProductDetail(id: Int64) async throws -> ProductDetailModel {
        try await APIClient.getProductDetail(id: id)
    }
}
