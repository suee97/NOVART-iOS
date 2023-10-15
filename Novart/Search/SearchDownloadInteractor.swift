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
            SearchProductModel(name: "작품이름", artistName: "작가이름", imageUrl: nil),
            SearchProductModel(name: "작품이름", artistName: "작가이름", imageUrl: nil),
            SearchProductModel(name: "작품이름", artistName: "작가이름", imageUrl: nil),
            SearchProductModel(name: "작품이름", artistName: "작가이름", imageUrl: nil)
            ]
        return items
    }
    
    func fetchArtistItems() async throws -> [SearchArtistModel] {
        let items = [
            SearchArtistModel(nickname: "작가 이름", backgroundImgUrl: nil, profileImgUrl: nil),
            SearchArtistModel(nickname: "작가 이름", backgroundImgUrl: nil, profileImgUrl: nil),
            SearchArtistModel(nickname: "작가 이름", backgroundImgUrl: nil, profileImgUrl: nil),
            SearchArtistModel(nickname: "작가 이름", backgroundImgUrl: nil, profileImgUrl: nil)
            ]
        return items
    }
}
