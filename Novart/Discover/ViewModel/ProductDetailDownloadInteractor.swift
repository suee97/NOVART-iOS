//
//  ProductDetailDownloadInteractor.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/28.
//

import Foundation

final class ProductDetailDownloadInteractor {
    func fetchProdcutDetail(id: String) async throws -> ProductDetailModel? {
        let response = try await APIClient.fetchProductDetail(id: id)
        return response.data
    }
}
