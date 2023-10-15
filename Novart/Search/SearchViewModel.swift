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
    
    init(data: SearchResultModel?, coordinator: SearchCoordinator) {
        self.coordinator = coordinator
        self.productViewModel = ProductSearchViewModel(data: data?.products ?? [], coordinator: coordinator)
        self.artistViewModel = ArtistSearchViewModel(data: data?.artists ?? [], coordinator: coordinator)
    }
    
    @MainActor
    private func presentNewSearchResultScene(with data: SearchResultModel) {
        coordinator?.navigate(to: .search(data))
    }
}

extension SearchViewModel {
    func didTapCategory(type: CategoryType) {
        print("tapped: \(type.rawValue)")
    }
}

extension SearchViewModel {
    
    // 새 검색 후 새 화면 진입할 때
    func performSearch(query: String) {
        Task {
            do {
                let result = try await searchWithQuery(query: query)
                DispatchQueue.main.async { [weak self] in
                    self?.presentNewSearchResultScene(with: result)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func searchWithQuery(query: String) async throws -> SearchResultModel {
        async let productData = downloadInteractor.searchProducts(query: query, pageNo: 0)
        async let artistData = downloadInteractor.searchArtists(query: query, pageNo: 0)
        
        let productResult = try await productData
        let artistResult = try await artistData
        
        return SearchResultModel(products: productResult.content, artists: artistResult.content)
    }
}
