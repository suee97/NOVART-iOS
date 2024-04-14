//
//  APIClient+Comment.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/28.
//

import Foundation
import Alamofire

extension APIClient {
    static func getProductComments(productId: Int64) async throws -> [CommentModel] {
        try await APIClient.request(target: CommentTarget.getProductComments(productId: productId), type: [CommentModel].self)
    }
    
    static func writeProductComment(productId: Int64, content: String) async throws -> CommentModel {
        try await APIClient.request(target: CommentTarget.writeProductComment(productId: productId, content: content), type: CommentModel.self)
    }
    
    static func getExhibitionComments(exhibitionId: Int64) async throws -> [CommentModel] {
        try await APIClient.request(target: CommentTarget.getExhibitionComments(exhibitionId: exhibitionId), type: [CommentModel].self)
    }
    
    static func writeExhibitionComment(exhibitionId: Int64, content: String) async throws -> CommentModel {
        try await APIClient.request(target: CommentTarget.writeExhibitionComment(exhibitionId: exhibitionId, content: content), type: CommentModel.self)
    }
    
    static func deleteProductComment(commentId: Int64) async throws -> EmptyResponseModel {
        try await APIClient.request(target: CommentTarget.deleteProductComment(commentId: commentId), type: EmptyResponseModel.self)
    }
    
    static func deleteExhibitionComment(commentId: Int64) async throws -> EmptyResponseModel {
        try await APIClient.request(target: CommentTarget.deleteProductComment(commentId: commentId), type: EmptyResponseModel.self)
    }
    
    static func editProductComment(commentId: Int64, content: String) async throws -> CommentModel {
        try await APIClient.request(target: CommentTarget.editProductComment(commentId: commentId, content: content), type: CommentModel.self)
    }
    
    static func editExhibitionComment(commentId: Int64, content: String) async throws -> CommentModel {
        try await APIClient.request(target: CommentTarget.editExhibitionComment(commentId: commentId, content: content), type: CommentModel.self)
    }
}
