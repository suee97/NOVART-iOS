//
//  CommentViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/28.
//

import Foundation
import Combine

final class CommentViewModel {

    private let commentInteractor: CommentInteractor = .init()
    
    let productId: Int64
    
    @Published var comments: [CommentModel] = []
    
    init(productId: Int64) {
        self.productId = productId
    }
    
}

extension CommentViewModel {
    func fetchComments() {
        Task { [weak self] in
            do {
                guard let self else { return }
                self.comments = try await commentInteractor.fetchComments(productId: self.productId)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func writeComment(content: String) {
        Task { [weak self] in
            do {
                guard let self else { return }
                let comment = try await commentInteractor.writeComment(productId: productId, content: content)
                self.comments.append(comment)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
