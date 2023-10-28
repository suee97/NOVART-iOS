//
//  CommentInteractor.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/28.
//

import Foundation

class CommentInteractor {
    func fetchComments(productId: Int64) async throws-> [CommentModel] {
        try await APIClient.getComments(productId: productId)
    }
}
