//
//  SearchProductModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/09/24.
//

import Foundation

struct SearchProductModel: Identifiable, Hashable {
    let id: UUID = UUID()
    let name: String
    let artistName: String
    let imageUrl: String?
}
