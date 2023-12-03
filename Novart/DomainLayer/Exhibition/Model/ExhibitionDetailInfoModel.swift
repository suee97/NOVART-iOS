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
    let category: [CategoryType]
    let count: Int
    let duration: Int
    let participants: [ParticipantModel]
    
    init(posterImageUrl: String?, title: String, subtitle: String, description: String, category: [CategoryType], count: Int, duration: Int, participants: [ParticipantModel]) {
        self.posterImageUrl = posterImageUrl
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.category = category
        self.count = count
        self.duration = duration
        self.participants = participants
    }
}

struct ParticipantModel: Identifiable {
    let id: UUID = UUID()
    let nickname: String
    let role: String
    let profileImageUrl: String?
}
