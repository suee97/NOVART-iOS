//
//  ArtistSearchViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/15.
//

import Foundation
import Combine

final class ArtistSearchViewModel {
    private weak var coordinator: SearchCoordinator?
    var downloadInteractor: SearchDownloadInteractor = SearchDownloadInteractor()
    
    var searchResultSubject: PassthroughSubject<[SearchArtistModel], Never> = .init()
    
    init(coordinator: SearchCoordinator?) {
        self.coordinator = coordinator
    }
}

extension ArtistSearchViewModel {
    func fetchData() {
        Task {
            let items = try await downloadInteractor.fetchArtistItems()
            searchResultSubject.send(items)
        }
    }
}
