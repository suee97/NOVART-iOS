//
//  APIClient+Media.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/01/07.
//

import Foundation
import Alamofire

extension APIClient {
    static func getPresignedUrl(filename: String, category: MediaTarget.Category) async throws -> PresignedUrlModel {
        try await APIClient.request(target: MediaTarget.getPresignedUrl(filename: filename, category: category), type: PresignedUrlModel.self)
    }
    
    static func getPresignedUrls(filenames: [String], categories: [MediaTarget.Category]) async throws -> [PresignedUrlModel] {
        try await APIClient.request(target: MediaTarget.getPresignedUrls(filenames: filenames, categories: categories), type: [PresignedUrlModel].self)
    }
        
}
