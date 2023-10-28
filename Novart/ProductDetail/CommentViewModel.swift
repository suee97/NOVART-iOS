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
    
    
//    let comments = [
//        CommentModel(id: 0, userId: 0, userProfileimgUrl: nil, userNickname: "방태림", content: "멋져요!😆", createdAt: "2일 전"),
//        CommentModel(id: 0, userId: 0, userProfileimgUrl: nil, userNickname: "방태림", content: "멋져요!😆", createdAt: "2일 전"),
//        CommentModel(id: 0, userId: 0, userProfileimgUrl: nil, userNickname: "방태림", content: "멋져요!😆", createdAt: "2일 전")
//    ]
    
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
}
