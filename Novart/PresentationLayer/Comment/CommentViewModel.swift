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
    
    func writeComment(content: String) {
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
}
