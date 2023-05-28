//
//  APIClient+Discover.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/28.
//

import Alamofire
import Foundation

extension APIClient {
    static func fetchProducts(parameters: Encodable?) async throws -> NetworkResponse<ProductSearchResultModel> {
        return try await APIClient.request(target: DiscoverTarget.fetchProduct(parameters: parameters), type: NetworkResponse<ProductSearchResultModel>.self)
    }
}
