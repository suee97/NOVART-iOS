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
    
    private weak var coordinator: (any Coordinator)?
    
    private let commentInteractor: CommentInteractor = .init()
    
    let contentId: Int64
    let contentType: ContentType
    
    @Published var comments: [CommentModel] = []
    let shouldEditCommentSubject: PassthroughSubject<CommentModel, Never> = .init()
    var isEditing: Bool = false
    var editingCommentModel: CommentModel?
    
    var user: PlainUser? {
        Authentication.shared.user
    }
    
    var userProfileImageUrl: String? {
        user?.profileImageUrl
    }
    
    init(contentId: Int64, contentType: ContentType, coordinator: (any Coordinator)? = nil) {
        self.contentId = contentId
        self.contentType = contentType
        self.coordinator = coordinator
    }
    
    @MainActor
    func showLoginModal() {
        switch coordinator {
        case let coordinator as ProductDetailCoordinator:
            coordinator.navigate(to: .login)
            coordinator.commentViewModel = nil
        case let coordinator as ExhibitionDetailCoordinator:
            coordinator.navigate(to: .login)
            coordinator.commentViewModel = nil
            
        case let coordinator as ExhibitionCoordinator:
            coordinator.navigate(to: .login)
            coordinator.commentViewModel = nil

        default:
            break
        }
    }
    
    @MainActor
    func showProfileViewController(userId: Int64) {
        switch coordinator {
        case let coordinator as ProductDetailCoordinator:
            coordinator.navigate(to: .artist(userId: userId))
            coordinator.commentViewModel = nil
            
        case let coordinator as ExhibitionDetailCoordinator:
            coordinator.navigate(to: .artist(userId: userId))
            coordinator.commentViewModel = nil
            
        case let coordinator as ExhibitionCoordinator:
            coordinator.navigate(to: .artist(userId: userId))
            coordinator.commentViewModel = nil
        default:
            break
        }
    }
    
    func showMoreActionSheet(commentId: Int64) {
        let alertController = AlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        guard let comment = comments.first(where: { $0.id == commentId }) else { return }
        
        let editAction = AlertAction(title: "의견 수정", style: .default) { [weak self] _ in
            self?.isEditing = true
            self?.editingCommentModel = comment
            self?.shouldEditCommentSubject.send(comment)
        }
        
        let deleteAction = AlertAction(title: "의견 삭제", style: .destructive) { [weak self] _ in
            self?.showDeleteAlert(commentId: commentId)
        }
        
        alertController.addAction(editAction)
        alertController.addAction(deleteAction)
        
        alertController.addCancelAction()
        alertController.show()
    }
    
    func showDeleteAlert(commentId: Int64) {
        let alertController = AlertController(title: nil, message: "의견을 삭제하시겠어요?", preferredStyle: .alert)
        
        let deleteAction = AlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let self else { return }
            Task {
                do {
                    try await self.deleteComment(commentId: commentId)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        alertController.addAction(deleteAction)
        
        alertController.addCancelAction()
        alertController.show()
    }
    
}

extension CommentViewModel {
    func fetchComments() {
        Task { [weak self] in
            do {
                guard let self else { return }
                switch contentType {
                case .exhibition:
                    self.comments = try await commentInteractor.fetchExhibitionComments(exhibitionId: self.contentId)
                case .product:
                    self.comments = try await commentInteractor.fetchProductComments(productId: self.contentId)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func didTapSendButton(content: String) {
        
        if isEditing {
            editComment(content: content)
        } else {
            writeComment(content: content)
        }
    }
    
    private func editComment(content: String) {
        Task { [weak self] in
            do {
                guard let self, let editingCommentModel else { return }
                
                switch contentType {
                case .exhibition:
                    let newComment = try await commentInteractor.editExhibitionComment(commentId: editingCommentModel.id, content: content)
                    if let index = comments.firstIndex(of: editingCommentModel) {
                        comments[index] = newComment
                    }
                case .product:
                    let newComment = try await commentInteractor.editProductComment(commentId: editingCommentModel.id, content: content)
                    if let index = comments.firstIndex(of: editingCommentModel) {
                        comments[index] = newComment
                    }
                }
                
                self.isEditing = false
                self.editingCommentModel = nil
            } catch {
                self?.isEditing = false
                self?.editingCommentModel = nil
                print(error.localizedDescription)
            }
        }
    }
    
    private func writeComment(content: String) {
        Task { [weak self] in
            do {
                guard let self else { return }
                
                switch contentType {
                case .exhibition:
                    let comment = try await commentInteractor.writeExhibitionComment(exhibitionId: self.contentId, content: content)
                    self.comments.append(comment)
                case .product:
                    let comment = try await commentInteractor.writeProductComment(productId: contentId, content: content)
                    self.comments.append(comment)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func deleteComment(commentId: Int64) async throws {
        guard let idx = comments.firstIndex(where: { $0.id == commentId }) else { return }
        
        switch contentType {
        case .product:
            try await commentInteractor.deleteProductComment(commentId: commentId)
        case .exhibition:
            try await commentInteractor.deleteExhibitionComment(commentId: commentId)
        }
        
        if comments.count > idx {
            comments.remove(at: idx)
        }
        PlainSnackbar.show(message: "의견을 삭제했어요.", configuration: .init(imageType: .none))
    }
}
