//
//  HomeDownloadInteractor.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/23.
//

import Foundation

final class HomeDownloadInteractor {
    func fetchFeedItems(category: CategoryType, lastId: Int64?) async throws -> [FeedItem] {
        try await APIClient.fetchFeed(category: category, lastId: lastId)
    }
}
