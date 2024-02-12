//
//  APIError.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/22.
//

import Foundation

enum ErrorCode: String {
    case UNKNOWN
    case TokenRefreshFail
    case invalidUrl
    
    init(fromRawValue: String) {
        self = ErrorCode(rawValue: fromRawValue) ?? .UNKNOWN
    }
}

extension ErrorCode: Codable {
    init(from decoder: Decoder) throws {
        self = try ErrorCode(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .UNKNOWN
    }
}

struct APIError: Decodable, Error {
    let message: String
    let code: ErrorCode
}
