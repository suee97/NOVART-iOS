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
    
    static func fetchProductDetail(id: String) async throws -> NetworkResponse<ProductDetailModel> {
        return try await APIClient.request(target: DiscoverTarget.fetchProductDetail(id: id), type: NetworkResponse<ProductDetailModel>.self)
    }
}
