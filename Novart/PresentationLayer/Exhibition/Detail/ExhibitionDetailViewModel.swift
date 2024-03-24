//
//  ExhibitionDetailViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/03.
//

import Foundation
import Combine

final class ExhibitionDetailViewModel {
    
    private weak var coordinator: ExhibitionDetailCoordinator?
    var detailInfoItemSubject: PassthroughSubject<[ExhibitionDetailViewController.Section: [ExhibitionDetailItem]], Never> = .init()
    var shortcutThumbnailUrlsSubject: PassthroughSubject<[String], Never> = .init()
    private let myPageInteractor: MyPageDownloadInteractor = .init()

    let exhibitionId: Int64
    
    private let exhibitionInteractor: ExhibitionInteractor = .init()
    
    init(coordinator: ExhibitionDetailCoordinator?, exhibitionId: Int64) {
        self.coordinator = coordinator
        self.exhibitionId = exhibitionId
    }
    
    @MainActor
    func closeCoordinator() {
        coordinator?.close()
    }
    
    @MainActor
    func showCommentViewController() {
        coordinator?.navigate(to: .comment(exhibitionId: exhibitionId))
    }
}

extension ExhibitionDetailViewModel {
    func loadData() {
        
        Task {
            do {
                let exhibitionData = try await exhibitionInteractor.fetchExhibitionDetail(exhibitionId: exhibitionId)
                let artItems = exhibitionData.arts.map { ExhibitionArtItem(item: $0) }
                let infoItem = ExhibitionDetailInfoModel(model: exhibitionData)
                let endItem = ExhibitionEndItem(likeCount: exhibitionData.likesCount, commentCount: exhibitionData.commentCount, likes: exhibitionData.likes)
                
                detailInfoItemSubject.send([.info: [infoItem], .art: artItems, .end: [endItem]])
                let shorcutThumbnailUrls = exhibitionData.arts.compactMap { $0.thumbnailImageUrls.first }
                shortcutThumbnailUrlsSubject.send(shorcutThumbnailUrls)
            } catch {
                print(error.localizedDescription)

            }
        }
    }
    
    func didTapFollowButton(id: Int64, shouldFollow: Bool) {
        if shouldFollow {
            makeFollowRequest(id: id)
        } else {
            makeCancelFollowRequest(id: id)
        }
    }
    
    func didTapLikeButton(shouldLike: Bool) {
        if shouldLike {
            makeLikeRequest()
        } else {
            makeUnlikeRequest()
        }
    }
}

private extension ExhibitionDetailViewModel {
    func makeFollowRequest(id: Int64) {
        Task {
            do {
                _ = try await myPageInteractor.follow(userId: id)
                DispatchQueue.main.async {
                    PlainSnackbar.show(message: "새로운 작가를 팔로우 했어요!", configuration: .init(imageType: .icon(.check), buttonType: .text("모두 보기"), buttonAction: nil))
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func makeCancelFollowRequest(id: Int64) {
        Task {
            do {
                _ = try await myPageInteractor.unFollow(userId: id)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func makeLikeRequest() {
        Task {
            do {
                try await exhibitionInteractor.makeLikeRequest(id: exhibitionId)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func makeUnlikeRequest() {
        Task {
            do {
                try await exhibitionInteractor.makeUnlikeRequest(id: exhibitionId)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
