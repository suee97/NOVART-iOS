//
//  CommentInteractor.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/28.
//

import Foundation

class CommentInteractor {
    func fetchProductComments(productId: Int64) async throws -> [CommentModel] {
        try await APIClient.getProductComments(productId: productId)
    }
    
    func writeProductComment(productId: Int64, content: String) async throws -> CommentModel {
        try await APIClient.writeProductComment(productId: productId, content: content)
    }
    
    func fetchExhibitionComments(exhibitionId: Int64) async throws -> [CommentModel] {
        try await APIClient.getExhibitionComments(exhibitionId: exhibitionId)
    }
    
    func writeExhibitionComment(exhibitionId: Int64, content: String) async throws -> CommentModel {
        try await APIClient.writeExhibitionComment(exhibitionId: exhibitionId, content: content)
    }
    
    func deleteComment(commentId: Int64) async throws {
        _ = try await APIClient.deleteProductComment(commentId: commentId)
    }
}
