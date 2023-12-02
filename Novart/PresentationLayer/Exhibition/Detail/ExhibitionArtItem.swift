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
    let titleImageUrls: [String]
    let title: String
    let artistName: String
    let description: String
    let detailImages: [ExhibitionDetailImage]
    
    
    init(titleImageUrls: [String], title: String, artistName: String, description: String, detailImages: [ExhibitionDetailImage]) {
        self.titleImageUrls = titleImageUrls
        self.title = title
        self.artistName = artistName
        self.description = description
        self.detailImages = detailImages
    }
}

struct ExhibitionDetailImage {
    let url: String
    let width: CGFloat
    let height: CGFloat
}
