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
        try await APIClient.request(target: CommentTarget.getComments(productId: productId), type: [CommentModel].self)
    }
    
    static func writeComment(productId: Int64, content: String) async throws -> CommentModel {
        try await APIClient.request(target: CommentTarget.writeComment(productId: productId, content: content), type: CommentModel.self)
    }
}
