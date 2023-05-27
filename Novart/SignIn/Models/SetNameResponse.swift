//
//  SetNameResponse.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/07.
//

import Foundation

struct SetNameResponse: Codable {
    let success: Bool
    let code: Int
    let message: String
    let data: [String: String]?
}

extension SetNameResponse {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? 0
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        data = try values.decodeIfPresent([String: String].self, forKey: .data)
    }
}
