//
//  MediaTarget.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/01/07.
//

import Foundation
import Alamofire

enum MediaTarget: TargetType {
    
    enum Category: String {
        case product
        case artist
    }
    
    case getPresignedUrl(filename: String, category: Category)
    case getPresignedUrls(filenames: [String], categories: [Category])

    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case .getPresignedUrl:
            return "s3/single"
        case .getPresignedUrls:
            return "s3/list"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getPresignedUrl, .getPresignedUrls:
            return .post
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case let .getPresignedUrl(filename, category):
            return .body([
                "filename": filename,
                "category": category.rawValue
            ])
        case let .getPresignedUrls(filenames, categories):
            let params = zip(filenames, categories).map{
                ["filename": $0, "category": $1.rawValue]
            }
            return .body([
                "files": params
            ])
        }
    }
}
