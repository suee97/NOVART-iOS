//
//  PageInfoModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/28.
//

import Foundation

struct PageInfoModel: Codable {
    let sort: SortInfoModel
    let offset: Int
    let pageNumber: Int
    let pageSize: Int
    let paged: Bool
    let unpaged: Bool
}

struct SortInfoModel: Codable {
    let empty: Bool
    let sorted: Bool
    let unsorted: Bool
}
