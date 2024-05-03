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
    
    var feedDataSubject: PassthroughSubject<([FeedItemViewModel], Bool), Never> = .init()
    var selectedCategory: CategoryType = .all
    
    private var isPaginationFinished: Bool?
    private var fetchedPages = [Int64]()
    private var isFetching = false
    
    private var feedData: [FeedItemViewModel] = []
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        setupObservers()
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
    
    @MainActor
    func showLoginModalScene() {
        coordinator?.navigate(to: .login)
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showLoginModal), name: .init(NotificationKeys.showLoginModalKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeLikeStatus), name: .init(NotificationKeys.changeHomeFeedLikeStatusKey), object: nil)
    }
    
    @objc
    private func showLoginModal() {
        DispatchQueue.main.async { [weak self] in
            self?.showLoginModalScene()
        }
    }
    
    @objc
    private func changeLikeStatus(notification: Notification) {
        guard let likeStatus = notification.object as? HomeFeedLikeStatusModel else { return }
        for item in feedData {
            if item.id == likeStatus.productId {
                item.changeLikeStatue(likeStatus: likeStatus)
                feedDataSubject.send((feedData, false))
                return
            }
        }
    }
}

extension HomeViewModel {
    func fetchItem(for id: Int) -> Int {
        return id
    }
    
    func loadInitialData() {
        fetchFeedItems(category: .all, lastId: nil)
    }

    func fetchFeedItems(category: CategoryType, lastId: Int64?, scrollToTop: Bool = true) {
        guard !isFetching else { return }
        if let lastId { fetchedPages.append(lastId) }
        Task {
            isFetching = true
            do {
                let items = try await downloadInteractor.fetchFeedItems(category: category, lastId: lastId)
                feedData = items.map { FeedItemViewModel($0) }
                feedDataSubject.send((feedData, scrollToTop))
                isPaginationFinished = (items.isEmpty)
            } catch {
                print(error)
            }
            isFetching = false
        }
    }
    
    func loadMoreItems() {
        guard !isFetching else { return }
        Task {
            do {
                isFetching = true
                let items = try await downloadInteractor.fetchFeedItems(category: selectedCategory, lastId: feedData.last?.id)
                feedData.append(contentsOf: items.map { FeedItemViewModel($0) })
                feedDataSubject.send((feedData, false))
                isPaginationFinished = (items.isEmpty)
            } catch {
                print(error)
            }
            isFetching = false
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
        let fetched = fetchedPages.contains(lastId)
        if fetched { return }
        fetchedPages.append(lastId)
        loadMoreItems()
    }
    
    func onRefresh() async {
        guard !isFetching else { return }
        isFetching = true
        do {
            try await Task.sleep(seconds: 1) // Test
            let items = try await downloadInteractor.fetchFeedItems(category: selectedCategory, lastId: nil)
            feedData = items.map { FeedItemViewModel($0) }
            feedDataSubject.send((feedData, true))
            isPaginationFinished = (items.isEmpty)
            fetchedPages.removeAll()
        } catch {
            print(error.localizedDescription)
        }
        isFetching = false
    }
}
