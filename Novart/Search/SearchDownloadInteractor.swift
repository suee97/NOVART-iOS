//
//  SearchDownloadInteractor.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/09/24.
//

import Foundation

final class SearchDownloadInteractor {
    func fetchProductItems() async throws -> [SearchProductModel] {
        let items = [
            SearchProductModel(id: 1, name: "작품이름", artistNickname: "작가이름", thumbnailImageUrl: nil),
            SearchProductModel(id: 2, name: "작품이름", artistNickname: "작가이름", thumbnailImageUrl: nil),
            SearchProductModel(id: 3, name: "작품이름", artistNickname: "작가이름", thumbnailImageUrl: nil),
            SearchProductModel(id: 4, name: "작품이름", artistNickname: "작가이름", thumbnailImageUrl: nil)
            ]
        return items
    }
    
    func fetchArtistItems() async throws -> [SearchArtistModel] {
        let items = [
            SearchArtistModel(id: 1, nickname: "작가이름", backgroundImgUrl: nil, profileImgUrl: nil),
            SearchArtistModel(id: 2, nickname: "작가이름", backgroundImgUrl: nil, profileImgUrl: nil),
            SearchArtistModel(id: 3, nickname: "작가이름", backgroundImgUrl: nil, profileImgUrl: nil),
            SearchArtistModel(id: 4, nickname: "작가이름", backgroundImgUrl: nil, profileImgUrl: nil),
            ]
        return items
    }
    
    func searchProducts(query: String, pageNo: Int32) async throws -> ProductSearchResponse {
        let response = try await APIClient.searchProduct(query: query, pageNo: pageNo)
        return response
    }
    
    func searchArtists(query: String, pageNo: Int32) async throws -> ArtistSearchResponse {
        let response = try await APIClient.searchArtist(query: query, pageNo: pageNo)
        return response
    }
}
