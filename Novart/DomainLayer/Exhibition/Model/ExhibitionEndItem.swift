//
//  ExhibitionEndItem.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/19.
//

import Foundation

final class ExhibitionEndItem: ExhibitionDetailItem {
    let exhibitionId: Int64
    let likeCount: Int
    let commentCount: Int
    let likes: Bool
    
    init(exhibitionId: Int64, likeCount: Int, commentCount: Int, likes: Bool) {
        self.exhibitionId = exhibitionId
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.likes = likes
    }
}
