//
//  APISerializer.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/22.
//

import Alamofire
import Foundation

final class APISerializer<T: Decodable>: ResponseSerializer {
    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    private lazy var serializer = DecodableResponseSerializer<T>(decoder: decoder)
    
    func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> Result<T, APIError> {
        guard error == nil else { return .failure(APIError(message: "Network Error", code: .UNKNOWN)) }
        guard let response = response else { return .failure(APIError(message: "Network Error", code: .UNKNOWN)) }

        do {
            if (200...299).contains(response.statusCode) {
                let result = try serializer.serialize(request: request, response: response, data: data, error: nil)
                return .success(result)
            } else {
                return .failure(APIError(message: "Network Error", code: .UNKNOWN))
            }
        } catch {
            return .failure(APIError(message: "Decode Error", code: .UNKNOWN))
        }
    }
    
}

