//
//  CategoryType.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/09/10.
//

import Foundation

enum CategoryType: String, CaseIterable, Decodable {
    case all = "전체"
    case painting = "회화"
    case craft = "공예"
    case graphic = "그래픽"
    case product = "제품"
    case fashion = "패션"
}
