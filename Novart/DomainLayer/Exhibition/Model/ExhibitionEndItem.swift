//
//  ExhibitionEndItem.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/19.
//

import Foundation

final class ExhibitionEndItem: ExhibitionDetailItem {
    let likeCount: Int
    let commentCount: Int
    let likes: Bool
    
    init(likeCount: Int, commentCount: Int, likes: Bool) {
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.likes = likes
    }
}
