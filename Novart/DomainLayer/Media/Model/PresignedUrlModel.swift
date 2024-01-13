//
//  PresignedUrlModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/01/07.
//

import Foundation

struct PresignedUrlModel: Decodable {
    let presignedUrl: String
    let imageUrl: String
}
