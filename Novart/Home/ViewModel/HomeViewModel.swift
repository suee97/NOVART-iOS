//
//  HomeViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/26.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var catalogItems: [CatalogItemModel] = []
    @Published var popularItems: [PopularProductItemModel] = []
    @Published var recentItems: [RecentProductItemModel] = []
    @Published var artistItems: [ArtistIntroItemModel] = []
    
    var catimg = PassthroughSubject<[CatalogItemModel], Never>()
    
    var downloadInteractor: HomeDownloadInteractor = HomeDownloadInteractor()
    
    init() {
        catimg
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.catalogItems = items
        }
            .store(in: &cancellables)
    }
    
    func fetchHomeItems() {
        fetchCatalogItems()
        fetchPopularItems()
        fetchRecentItems()
        fetchArtistIntroItems()
    }
    
    private func fetchCatalogItems() {
        
        Task {
            do {
                let items = try await downloadInteractor.fetchCatalogItems() ?? []
                catimg.send(items)
                print(items.count)
            } catch {
                print(error)
            }
        }
    }
    
    private func fetchPopularItems() {
        popularItems = downloadInteractor.fetchPopularItems()
    }
    
    private func fetchRecentItems() {
        recentItems = downloadInteractor.fetchRecentItems()
    }
    
    private func fetchArtistIntroItems() {
        artistItems = downloadInteractor.fetchArtistIntroItems()
    }
}
