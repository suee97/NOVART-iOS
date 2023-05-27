//
//  APIClient+Home.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/26.
//

import Alamofire
import Foundation

extension APIClient {
    static func fetchCatalog() async throws -> NetworkResponse<[CatalogItemModel]> {
        return try await APIClient.request(target: HomeTarget.fetchCatalog, type: NetworkResponse<[CatalogItemModel]>.self)
    }
}
