//
//  APIError.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/29.
//

import Foundation

enum ErrorCode: String {
    case UNKNOWN
    
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
