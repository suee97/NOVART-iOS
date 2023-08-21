//
//  HomeViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/06.
//

import Foundation
import Combine

final class HomeViewModel {
    private weak var coordinator: HomeCoordinator?
    var downloadInteractor: HomeDownloadInteractor = HomeDownloadInteractor()
    
    var feedDataSubject: PassthroughSubject<[FeedItemViewModel], Never> = .init()
    
    private var feedData: [FeedItemViewModel] = [] {
        didSet {
            feedDataSubject.send(feedData)
        }
    }
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
}

extension HomeViewModel {
    func fetchItem(for id: Int) -> Int {
        return id
    }
    
    func fetchData() {
        fetchFeedItems()
    }

    func fetchFeedItems() {
        Task {
            do {
                let items = try await downloadInteractor.fetchFeedItems() ?? []
                feedData = items.map { FeedItemViewModel($0) }
            } catch {
                print(error)
            }
        }
    }
}
