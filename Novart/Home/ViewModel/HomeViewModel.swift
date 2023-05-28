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
        
    var downloadInteractor: HomeDownloadInteractor = HomeDownloadInteractor()
    
    init() {
    }
    
    func fetchHomeItems() {
        fetchCatalogItems()
        fetchPopularItems()
        fetchRecentItems()
        fetchArtistIntroItems()
    }
    
    private func fetchCatalogItems() {
        
        Task { @MainActor in
            do {
                catalogItems = try await downloadInteractor.fetchCatalogItems() ?? []
            } catch {
                print(error)
            }
        }
    }
    
    private func fetchPopularItems() {
        Task { @MainActor in
            do {
                popularItems = try await downloadInteractor.fetchPopularItems() ?? []
            } catch {
                print(error)
            }
        }
    }
    
    private func fetchRecentItems() {
        Task { @MainActor in
            do {
                recentItems = try await downloadInteractor.fetchRecentItems() ?? []
            } catch {
                print(error)
            }
        }
    }
    
    private func fetchArtistIntroItems() {
        Task { @MainActor in
            do {
                artistItems = try await downloadInteractor.fetchArtistIntroItems() ?? []
            } catch {
                print(error)
            }
        }
    }
}
