//
//  CatalogItemResponse.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/26.
//

import Foundation

struct CatalogItemResponse: Codable {
    let success: Bool
    let code: Int
    let message: String
    let dataList: [CatalogItemModel]?
}

extension CatalogItemResponse {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? 0
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        
        dataList = try values.decodeIfPresent([CatalogItemModel].self, forKey: .dataList)
    }
}
