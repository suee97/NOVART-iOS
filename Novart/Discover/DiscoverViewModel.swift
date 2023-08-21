//
//  DiscoverViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/16.
//

import Foundation
import Combine

final class DiscoverViewModel {
    private weak var coordinator: DiscoverCoordinator?
    
    var productDataSubject: PassthroughSubject<[Int], Never> = .init()
    
    private var productData: [Int] = [] {
        didSet {
            productDataSubject.send(productData)
        }
    }
    
    init(coordinator: DiscoverCoordinator) {
        self.coordinator = coordinator
    }
}

extension DiscoverViewModel {
    
    func fetchItem(for id: Int) -> Int {
        return id
    }
    
    func fetchData() {
        productData = [1, 2, 3, 4, 5, 6, 7, 8]
    }
}
