//
//  ExhibitionDetailModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/02.
//

import Foundation

struct ExhibitionDetailModel: Decodable, Hashable {
    let id: Int64
    let name: String
    let englishName: String
    let posterImageUrl: String
    let arts: [ExhibitionDetailArtItem]
    let artists: [ExhibitionParticipantModel]
    let likesCount: Int
    let commentCount: Int
    let likes: Bool
    let estimatedDuration: String
    let artCount: String
    let description: String
    let category: String?
    
    static func == (lhs: ExhibitionDetailModel, rhs: ExhibitionDetailModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct ExhibitionDetailArtItem: Decodable {
    let id: Int64
    let description: String
    let thumbnailImageUrls: [String]
    let detailImageInfo: [ExhibitionDetailImageInfoModel]
    let artistFollow: ExhibitionArtistFollowInfoModel
}

struct ExhibitionDetailImageInfoModel: Decodable {
    let url: String
    let width: Int
    let height: Int
}

struct ExhibitionArtistFollowInfoModel: Decodable {
    let userId: Int64
    let nickname: String
    let profileImageUrl: String?
    let following: Bool
    let email: String?
    let openChatUrl: String?
}

struct ExhibitionParticipantModel: Decodable {
    let id: Int64
    let profileImageUrl: String?
    let nickname: String
    let job: String
}
