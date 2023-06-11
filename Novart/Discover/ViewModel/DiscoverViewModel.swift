//
//  DiscoverViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/28.
//

import Foundation

class DiscoverViewModel: ObservableObject {
    
    @Published var products: [PopularProductItemModel] = []
    @Published var selectedCategory: NovartItemCategory = .all
    @Published var isOnlyPurchasable: Bool = false
    @Published var listOrderType: ListOrderType = .popular
    
    let downloadInteractor: DiscoverDownloadInteractor = DiscoverDownloadInteractor()
    
    init() {
    }
    
    func fetchProducts() {
        Task { @MainActor in
            do {
                let searchResult = try await downloadInteractor.fetchProducts(parameters: nil)
                products = searchResult?.content ?? []
            } catch {
                print(error)
            }
        }
    }
}

enum ListOrderType {
    case new
    case popular
    case highPrice
    case lowPrice
}
