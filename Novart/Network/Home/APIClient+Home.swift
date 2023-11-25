//
//  APIClient+Home.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/23.
//

import Alamofire
import Foundation

extension APIClient {
    static func fetchFeed() async throws -> FeedResponse {
        try await APIClient.request(target: HomeTarget.fetchFeed, type: FeedResponse.self)
    }
}
