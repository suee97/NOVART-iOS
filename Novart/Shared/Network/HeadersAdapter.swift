//
//  HeadersAdapter.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/22.
//

import Alamofire
import Foundation

class HeadersAdapter: RequestAdapter {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.setValue("application/json", forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        urlRequest.setValue("application/json", forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        
        completion(.success(urlRequest))
    }
}

