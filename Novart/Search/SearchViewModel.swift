//
//  SearchViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/09/21.
//

import Foundation

final class SearchViewModel {
    private weak var coordinator: SearchCoordinator?
    
    var categoryItems: [CategoryType] = CategoryType.allCases
    
    init(coordinator: SearchCoordinator) {
        self.coordinator = coordinator
    }
}

extension SearchViewModel {
    func didTapCategory(type: CategoryType) {
        print("tapped: \(type.rawValue)")
    }
}
