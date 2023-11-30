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
    var searchResult: SearchResultModel?
    var currentCategory: CategoryType
    var currentQuery: String
    
    init(data: SearchResultModel?, coordinator: SearchCoordinator) {
        self.coordinator = coordinator
        self.productViewModel = ProductSearchViewModel(data: data?.products ?? [], coordinator: coordinator)
        self.artistViewModel = ArtistSearchViewModel(data: data?.artists ?? [], coordinator: coordinator)
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
                    async let productData = self.downloadInteractor.searchProducts(query: "", pageNo: 0, category: currentCategory)
                    async let artistData = self.downloadInteractor.searchArtists(query: "", pageNo: 0, category: currentCategory)
                    
                    let productResult = try await productData
                    let artistResult = try await artistData
                    
                    productViewModel.products = productResult.content
                    artistViewModel.artists = artistResult.content
                } catch {
                    print(error.localizedDescription)
                }
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
        
        return SearchResultModel(query: query, products: productResult.content, artists: artistResult.content, category: currentCategory)
    }
}
