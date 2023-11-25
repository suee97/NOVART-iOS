//
//  CategoryType.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/09/10.
//

import Foundation

enum CategoryType: String, CaseIterable, Decodable {
    case all = "전체"
    case product = "제품"
    case craft = "공예"
    case painting = "그림"
    case graphic = "그래픽"
    case fashion = "패션"
}
