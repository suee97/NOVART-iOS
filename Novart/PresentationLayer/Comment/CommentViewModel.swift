//
//  CommentViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/28.
//

import Foundation
import Combine

final class CommentViewModel {

    enum ContentType {
        case product
        case exhibition
    }
    
    private let commentInteractor: CommentInteractor = .init()
    
    let contentId: Int64
    let contentType: ContentType
    
    @Published var comments: [CommentModel] = []
    
    init(contentId: Int64, contentType: ContentType) {
        self.contentId = contentId
        self.contentType = contentType
    }
    
}

extension CommentViewModel {
    func fetchComments() {
        Task { [weak self] in
            do {
                guard let self else { return }
                self.comments = try await commentInteractor.fetchProductComments(productId: self.contentId)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func writeComment(content: String) {
        Task { [weak self] in
            do {
                guard let self else { return }
                let comment = try await commentInteractor.writeProductComment(productId: contentId, content: content)
                self.comments.append(comment)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
