//
//  APIClient+Comment.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/28.
//

import Foundation
import Alamofire

extension APIClient {
    static func getComments(productId: Int64) async throws -> [CommentModel] {
        try await APIClient.request(target: CommentTarget.getComments(id: productId), type: [CommentModel].self)
    }
}
