//
//  ExhibitionDetailInfoModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/05.
//

import Foundation

class ExhibitionDetailInfoModel: ExhibitionDetailItem {
    let posterImageUrl: String?
    let title: String
    let subtitle: String
    let description: String
    let category: String?
    let count: String
    let duration: String
    let participants: [ExhibitionParticipantModel]
    let shortcutThumbnailUrls: [String]
    
    init(model: ExhibitionDetailModel) {
        self.posterImageUrl = model.posterImageUrl
        self.title = model.name
        self.subtitle = model.englishName
        self.description = model.description
        self.category = model.category
        self.count = model.artCount
        self.duration = model.estimatedDuration
        self.participants = model.artists
        self.shortcutThumbnailUrls = model.arts.compactMap { $0.thumbnailImageUrls.first }
    }
}
