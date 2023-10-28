//
//  CommentModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/28.
//

import Foundation

struct CommentModel: Identifiable, Hashable, Decodable {
    let id: Int64
    let userId: Int64
    let userProfileimgUrl: String?
    let userNickname: String
    let content: String
    let createdAt: String
}
