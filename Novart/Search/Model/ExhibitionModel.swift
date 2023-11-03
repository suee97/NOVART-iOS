//
//  ExhibitionModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/22.
//

import Foundation

class ExhibitionModel: PlainItem, Decodable {
    let name: String
    let date: String
    
    init(name: String, date: String) {
        self.name = name
        self.date = date
    }
}
