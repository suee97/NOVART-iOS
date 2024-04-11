//
//  SearchViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/09/21.
//

import Foundation
import Combine

final class SearchViewModel {
    weak var coordinator: SearchCoordinator?
    var downloadInteractor: SearchDownloadInteractor = SearchDownloadInteractor()

    var categoryItems: [CategoryType] = CategoryType.allCases
    var productViewModel: ProductSearchViewModel
    var artistViewModel: ArtistSearchViewModel
    @Published var searchResult: SearchResultModel?
    @Published var recentSearch: [String] = []
    var currentCategory: CategoryType
    var currentQuery: String
    
    init(data: SearchResultModel?, coordinator: SearchCoordinator) {
        self.coordinator = coordinator
        self.productViewModel = ProductSearchViewModel(data: data, coordinator: coordinator)
        self.artistViewModel = ArtistSearchViewModel(data: data, coordinator: coordinator)
        self.currentCategory = data?.category ?? .all
        self.currentQuery = data?.query ?? ""
        self.searchResult = data
    }
    
    @MainActor
    private func presentNewSearchResultScene(with data: SearchResultModel) {
        coordinator?.navigate(to: .search(data))
    }
}

extension SearchViewModel {
    func didTapCategory(type: CategoryType) {
        print("tapped: \(type.rawValue)")
        currentCategory = type
        changeSearchCategory()
    }
}

extension SearchViewModel {
    
    func loadIntialData() {
        if searchResult == nil {
            Task { [weak self] in
                guard let self else { return }
                do {
                    async let recentSearch = self.downloadInteractor.getRecentSearch()
                    async let productData = self.downloadInteractor.searchProducts(query: "", pageNo: 0, category: currentCategory)
                    async let artistData = self.downloadInteractor.searchArtists(query: "", pageNo: 0, category: currentCategory)
                    
                    let productResult = try await productData
                    let artistResult = try await artistData
                    self.recentSearch = try await recentSearch.filter { !$0.isEmpty }
                    
                    productViewModel.products = productResult.content
                    artistViewModel.artists = artistResult.content

                    productViewModel.searchResultData = SearchResultModel(query: "", products: productResult.content, artists: artistResult.content, category: currentCategory, isLastPage: (products: productResult.last, artists: artistResult.last))
                    productViewModel.isLastPage = productResult.last
                    
                    artistViewModel.searchResultData = SearchResultModel(query: "", products: productResult.content, artists: artistResult.content, category: currentCategory, isLastPage: (products: productResult.last, artists: artistResult.last))
                    artistViewModel.isLastPage = artistResult.last
                    
                    searchResult = SearchResultModel(query: "", products: productResult.content, artists: artistResult.content, category: currentCategory, isLastPage: (products: productResult.last, artists: artistResult.last))
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            Task { [weak self] in
                guard let self else { return }
                let recentSearch = try await self.downloadInteractor.getRecentSearch()
                self.recentSearch = recentSearch.filter { !$0.isEmpty }
            }
        }
    }
    
    // 새 검색 후 새 화면 진입할 때
    func performSearch(query: String) {
        Task {
            do {
                let result = try await searchWithQuery(query: query, category: currentCategory)
                DispatchQueue.main.async { [weak self] in
                    self?.presentNewSearchResultScene(with: result)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // 카테고리만 변경 했을 때
    func changeSearchCategory() {
        Task { [weak self] in
            guard let self else { return }
            do {
                async let productData = self.downloadInteractor.searchProducts(query: currentQuery, pageNo: 0, category: currentCategory)
                async let artistData = self.downloadInteractor.searchArtists(query: currentQuery, pageNo: 0, category: currentCategory)
                
                let productResult = try await productData
                let artistResult = try await artistData
                
                productViewModel.products = productResult.content
                artistViewModel.artists = artistResult.content
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func searchWithQuery(query: String, category: CategoryType) async throws -> SearchResultModel {
        async let productData = downloadInteractor.searchProducts(query: query, pageNo: 0, category: category)
        async let artistData = downloadInteractor.searchArtists(query: query, pageNo: 0, category: category)
        
        let productResult = try await productData
        let artistResult = try await artistData
        
        return SearchResultModel(query: query, products: productResult.content, artists: artistResult.content, category: currentCategory, isLastPage: (products: productResult.last, artists: artistResult.last))
    }
    
    func deleteRecent(query: String) {
        guard let idx = recentSearch.firstIndex(of: query) else { return }
        recentSearch.remove(at: idx)
        serverDeleteRecent(query: query)
    }
    
    func deleteAllRecent() {
        guard !recentSearch.isEmpty else { return }
        recentSearch = []
        serverDeleteAll()
    }
    
    private func serverDeleteRecent(query: String) {
        Task {
            try await downloadInteractor.deleteRecentQuery(query: query)
        }
    }
    
    private func serverDeleteAll() {
        Task {
            try await downloadInteractor.deleteAllRecentQuery()
        }
    }
}
