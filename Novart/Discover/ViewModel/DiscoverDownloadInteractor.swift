//
//  DiscoverDownloadInteractor.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/28.
//

import Foundation

final class DiscoverDownloadInteractor {
    func fetchProducts(parameters: Encodable?) async throws -> ProductSearchResultModel? {
        let response = try await APIClient.fetchProducts(parameters: parameters)
        return response.data
    }
}
