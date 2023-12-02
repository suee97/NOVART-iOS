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
    
    init(likeCount: Int, commentCount: Int) {
        self.likeCount = likeCount
        self.commentCount = commentCount
    }
}
