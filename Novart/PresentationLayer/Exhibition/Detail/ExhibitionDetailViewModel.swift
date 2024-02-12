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
                let endItem = ExhibitionEndItem(likeCount: exhibitionData.likesCount, commentCount: exhibitionData.commentCount)
                
                detailInfoItemSubject.send([.info: [infoItem], .art: artItems, .end: [endItem]])
                let shorcutThumbnailUrls = exhibitionData.arts.compactMap { $0.thumbnailImageUrls.first }
                shortcutThumbnailUrlsSubject.send(shorcutThumbnailUrls)
            } catch {
                print(error.localizedDescription)

            }
        }
    }
    
}
