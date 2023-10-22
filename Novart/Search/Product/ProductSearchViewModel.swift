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
    
    @Published var products: [SearchProductModel]
    
    var searchResultSubject: PassthroughSubject<[SearchProductModel], Never> = .init()
    
    init(data: [SearchProductModel], coordinator: SearchCoordinator?) {
        self.products = data
        self.coordinator = coordinator
    }
}

extension ProductSearchViewModel {
    func fetchData() {
        Task {
            let items = try await downloadInteractor.fetchProductItems()
            searchResultSubject.send(items)
        }
    }
}
