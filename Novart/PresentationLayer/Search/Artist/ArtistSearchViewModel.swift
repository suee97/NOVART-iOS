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
    
    @Published var artists: [ArtistModel]
    var searchResultData: SearchResultModel?
    var curPageNum: Int32 = 0
    var isLastPage: Bool
    var isFetching = false
        
    init(data: SearchResultModel?, coordinator: SearchCoordinator?) {
        self.artists = data?.artists ?? []
        self.searchResultData = data
        self.isLastPage = data?.isLastPage.artists ?? true
        self.coordinator = coordinator
    }
}


// MARK: - Pagination
extension ArtistSearchViewModel {
    func loadMoreItems() {
        Task {
            do {
                isFetching = true
                guard let searchResultData else { return }
                let response = try await downloadInteractor.searchArtists(query: searchResultData.query, pageNo: curPageNum + 1, category: searchResultData.category)
                isLastPage = response.last
                artists.append(contentsOf: response.content)
                curPageNum = Int32(response.pageable.pageNumber)
            } catch {
                print(error.localizedDescription)
            }
            isFetching = false
        }
    }
    
    func scrollViewDidReachBottom() {
        guard !isLastPage, !isFetching else { return }
        loadMoreItems()
    }
    
    func onRefresh() async {
        guard !isFetching else { return }
        do {
            isFetching = true
            try await Task.sleep(seconds: 1) // Test
            guard let searchResultData else { return }
            let response = try await downloadInteractor.searchArtists(query: searchResultData.query, pageNo: 0, category: searchResultData.category)
            isLastPage = response.last
            artists = response.content
            curPageNum = 0
        } catch {
            print(error.localizedDescription)
        }
        isFetching = false
    }
}
