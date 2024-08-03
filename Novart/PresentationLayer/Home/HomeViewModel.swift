//
//  HomeViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/06.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel {
    private weak var coordinator: HomeCoordinator?
    
    let likeProductUseCase: LikeProductUseCase
    let unlikeProductUseCase: UnlikeProductUseCase
    let fetchProductsUseCase: FetchProductsUseCase
    
    var feedDataSubject: PassthroughSubject<([FeedItemViewModel], Bool), Never> = .init()
    var selectedCategory: CategoryType = .all
    
    private var isPaginationFinished: Bool?
    private var fetchedPages = [Int64]()
    private var isFetching = false
    
    private var feedData: [FeedItemViewModel] = []
    
    init(coordinator: HomeCoordinator, repository: HomeRepositoryInterface) {
        self.coordinator = coordinator
        self.likeProductUseCase = .init(repository: repository)
        self.unlikeProductUseCase = .init(repository: repository)
        self.fetchProductsUseCase = .init(repository: repository)
        setupObservers()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showLoginModal), name: .init(NotificationKeys.showLoginModalKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeLikeStatus), name: .init(NotificationKeys.changeHomeFeedLikeStatusKey), object: nil)
    }
    
}

// MARK: - Open
extension HomeViewModel {

    func didTapProductLikeButton(productID: Int64, like: Bool) {
        Task {
            do {
                if like {
                    try await likeProductUseCase.execute(productID: productID)
                } else {
                    try await unlikeProductUseCase.execute(productID: productID)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func didTapProduct(index: Int) {
        let productId = feedData[index].id
        presentProductDetailScene(productId: productId)
    }
    
    func didChangeCategory(category: CategoryType) {
        fetchFeedItems(category: category, lastId: nil)
    }
    
    func shouldShowNicknameSceneIfNeeded() {
        if Authentication.shared.isFirstLogin {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.showSetNicknameScene()
            }
        }
    }
    
    func loadInitialData() {
        fetchFeedItems(category: .all, lastId: nil)
    }
    
    func fetchProducts(category: CategoryType, lastID: Int64?) {
        fetchFeedItems(category: category, lastId: lastID)
    }
    
    func scrollViewDidReachBottom() {
        loadMoreProducts()
    }
    
    func onRefresh() async {
        guard !isFetching else { return }
        isFetching = true
        do {
            try await Task.sleep(seconds: 1) // Test
            let items = try await fetchProductsUseCase.execute(category: selectedCategory, lastProductID: nil)
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

// MARK: - Navigation
private extension HomeViewModel {
    func showSetNicknameScene() {
        coordinator?.presentSetNicknameModal()
    }
    
    func presentProductDetailScene(productId: Int64) {
        coordinator?.navigate(to: .productDetail(id: productId))
    }
    
    func showLoginModalScene() {
        coordinator?.navigate(to: .login)
    }
}

// MARK: - Selectors
private extension HomeViewModel {
    
    @objc
    func showLoginModal() {
        DispatchQueue.main.async { [weak self] in
            self?.showLoginModalScene()
        }
    }
    
    @objc
    func changeLikeStatus(notification: Notification) {
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


    private func fetchFeedItems(category: CategoryType, lastId: Int64?, scrollToTop: Bool = true) {
        guard !isFetching else { return }
        if let lastId { fetchedPages.append(lastId) }
        Task {
            isFetching = true
            do {
                let items = try await fetchProductsUseCase.execute(category: category, lastProductID: lastId)
                feedData = items.map { FeedItemViewModel($0) }
                feedDataSubject.send((feedData, scrollToTop))
                isPaginationFinished = (items.isEmpty)
            } catch {
                print(error)
            }
            isFetching = false
        }
    }
    
    private func loadMoreItems() {
        guard !isFetching else { return }
        Task {
            do {
                isFetching = true
                let items = try await fetchProductsUseCase.execute(category: selectedCategory, lastProductID: feedData.last?.id)
                feedData.append(contentsOf: items.map { FeedItemViewModel($0) })
                feedDataSubject.send((feedData, false))
                isPaginationFinished = (items.isEmpty)
            } catch {
                print(error)
            }
            isFetching = false
        }
    }
    
    private func loadMoreProducts() {
        guard let isPaginationFinished, !isPaginationFinished, let lastId = feedData.last?.id else { return }
        let fetched = fetchedPages.contains(lastId)
        if fetched { return }
        fetchedPages.append(lastId)
        loadMoreItems()
    }
}
