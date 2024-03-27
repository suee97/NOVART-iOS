//
//  ProductSearchViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/15.
//

import Foundation
import Combine

final class ProductSearchViewModel {
    private weak var coordinator: SearchCoordinator?
    var downloadInteractor: SearchDownloadInteractor = SearchDownloadInteractor()
    
    @Published var products: [ProductModel]
    var searchResultData: SearchResultModel?
    var curPageNum: Int32 = 0
    var isLastPage: Bool
    var fetchedPages: [Int32] = [0]
    var isPageLoading = false
    
    init(data: SearchResultModel?, coordinator: SearchCoordinator?) {
        self.products = data?.products ?? []
        self.searchResultData = data
        self.isLastPage = data?.isLastPage.products ?? true
        self.coordinator = coordinator
    }
    
    @MainActor
    func presentProductDetailScene(productId: Int64) {
        coordinator?.navigate(to: .product(productId))
    }
}


// MARK: - Pagination
extension ProductSearchViewModel {
    func loadMoreItems() {
        Task {
            do {
                guard let searchResultData else { return }
                isPageLoading = true
                let response = try await downloadInteractor.searchProducts(query: searchResultData.query, pageNo: curPageNum + 1, category: searchResultData.category)
                isLastPage = response.last
                products.append(contentsOf: response.content)
                curPageNum = Int32(response.pageable.pageNumber) + 1
            } catch {
                print(error.localizedDescription)
            }
            isPageLoading = false
        }
    }
    
    func scrollViewDidReachBottom() {
        guard !isLastPage, !isPageLoading else { return }
        loadMoreItems()
    }
}
