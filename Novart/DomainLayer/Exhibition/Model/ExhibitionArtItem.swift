//
//  ExhibitionArtItem.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/05.
//

import UIKit
import Combine
import Kingfisher

final class ExhibitionArtItem: ExhibitionDetailItem {
    let artId: Int64
    let description: String
    let title: String
    let subtitle: String
    let thumbnailImageUrls: [String]
    let detailImages: [ExhibitionDetailImageInfoModel]
    let artistInfo: ExhibitionArtistFollowInfoModel
    
    init(artId: Int64, description: String, title: String, subtitle: String, thumbnailImageUrls: [String], detailImages: [ExhibitionDetailImageInfoModel], artistInfo: ExhibitionArtistFollowInfoModel) {
        self.artId = artId
        self.description = description
        self.title = title
        self.subtitle = subtitle
        self.thumbnailImageUrls = thumbnailImageUrls
        self.detailImages = detailImages
        self.artistInfo = artistInfo
    }
    
    init(item: ExhibitionDetailArtItem) {
        self.artId = item.id
        self.description = item.description
        self.thumbnailImageUrls = item.thumbnailImageUrls
        self.title = "Temp"
        self.subtitle = "Subtitle"
        self.detailImages = item.detailImageInfo
        self.artistInfo = item.artistFollow
    }
}
