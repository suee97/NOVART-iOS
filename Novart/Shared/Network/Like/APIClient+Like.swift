//
//  APIClient+Like.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/11.
//

import Alamofire
import Foundation

extension APIClient {
    static func postLike(id: String) async throws -> NetworkResponse<LikeResultModel> {
        return try await APIClient.request(target: LikeTarget.postLike(id: id), type: NetworkResponse<LikeResultModel>.self)
    }
}
