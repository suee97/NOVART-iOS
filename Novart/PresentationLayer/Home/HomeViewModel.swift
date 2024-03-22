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
    var selectedCategory: CategoryType = .all
    
    private var isPaginationFinished: Bool?
    private var isFeedFetched: [Int64 : Bool] = [:]
    
    private var feedData: [FeedItemViewModel] = [] {
        didSet {
            feedDataSubject.send(feedData)
        }
    }
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
    
    @MainActor
    func showSetNicknameSceneIfNeeded() {
        if Authentication.shared.isFirstLogin {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.coordinator?.presentSetNicknameModal()
            }
        }
    }
    
    @MainActor
    func presentProductDetailScene(productId: Int64) {
        coordinator?.navigate(to: .productDetail(id: productId))
    }
    
    @MainActor
    func didSelectProductAt(index: Int) {
        let productId = feedData[index].id
        presentProductDetailScene(productId: productId)
    }
}

extension HomeViewModel {
    func fetchItem(for id: Int) -> Int {
        return id
    }
    
    func loadInitialData() {
        fetchFeedItems(category: .all, lastId: nil)
    }

    func fetchFeedItems(category: CategoryType, lastId: Int64?) {
        if let lastId { isFeedFetched[lastId] = true }
        Task {
            do {
                let items = try await downloadInteractor.fetchFeedItems(category: category, lastId: lastId)
                feedData = items.map { FeedItemViewModel($0) }
                isPaginationFinished = items.count == 0
            } catch {
                print(error)
            }
        }
    }
    
    func loadMoreItems() {
        Task {
            do {
                let items = try await downloadInteractor.fetchFeedItems(category: selectedCategory, lastId: feedData.last?.id)
                feedData.append(contentsOf: items.map { FeedItemViewModel($0) })
                isPaginationFinished = items.count == 0
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor
    func tempInfoCall() {
        let userInteractor = UserInteractor()
        Task {
            do {
                let user = try await userInteractor.getUserInfo()
                print("성공")
                print(user.nickname)
            } catch {
                print("이거 실패")
            }
        }
    }
    
    func scrollViewDidReachBottom() {
        guard let isPaginationFinished, !isPaginationFinished, let lastId = feedData.last?.id else { return }
        let fetched = isFeedFetched[lastId] ?? false
        if fetched { return }
        isFeedFetched[lastId] = true
        loadMoreItems()
    }
}
