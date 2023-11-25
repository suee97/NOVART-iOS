//
//  HomeDownloadInteractor.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/23.
//

import Foundation

final class HomeDownloadInteractor {
    
    func fetchFeedItems() async throws -> [FeedItem] {
        let feedData = try await APIClient.fetchFeed()
        return feedData.content
    }
}
