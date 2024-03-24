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
    var fetchedPages: [Int32] = [0]
    var isPageLoading = false
        
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
                guard let searchResultData else { return }
                isPageLoading = true
                let response = try await downloadInteractor.searchArtists(query: searchResultData.query, pageNo: curPageNum + 1, category: searchResultData.category)
                isLastPage = response.last
                artists.append(contentsOf: response.content)
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
