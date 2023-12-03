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
    
    init(posterImageUrl: String?, title: String, subtitle: String, description: String, category: String, count: String, duration: String, participants: [ExhibitionParticipantModel]) {
        self.posterImageUrl = posterImageUrl
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.category = category
        self.count = count
        self.duration = duration
        self.participants = participants
    }
    
    init(model: ExhibitionDetailModel) {
        self.posterImageUrl = model.posterImageUrl
        self.title = model.name
        self.subtitle = model.englishName
        self.description = model.description
        self.category = model.category
        self.count = model.artCount
        self.duration = model.estimatedDuration
        self.participants = model.artists
    }
}
