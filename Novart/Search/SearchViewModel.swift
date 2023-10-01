//
//  SearchViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/09/21.
//

import Foundation
import Combine

final class SearchViewModel {
    private weak var coordinator: SearchCoordinator?
    var downloadInteractor: SearchDownloadInteractor = SearchDownloadInteractor()

    var categoryItems: [CategoryType] = CategoryType.allCases
    
    var searchResultSubject: PassthroughSubject<[SearchProductModel], Never> = .init()
    
    init(coordinator: SearchCoordinator) {
        self.coordinator = coordinator
    }
}

extension SearchViewModel {
    func didTapCategory(type: CategoryType) {
        print("tapped: \(type.rawValue)")
    }
}

extension SearchViewModel {
    func fetchData() {
        Task {
            let items = try await downloadInteractor.fetchProductItems()
            searchResultSubject.send(items)
        }
    }
}
