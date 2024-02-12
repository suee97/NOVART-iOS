//
//  APIClient+Product.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/22.
//

import Foundation
import Alamofire

extension APIClient {
    static func getProductDetail(id: Int64) async throws -> ProductDetailModel {
        try await APIClient.request(target: ProductTarget.productDetail(id: id), type: ProductDetailModel.self)
    }
    
    static func uploadProduct(product: ProductUploadRequestModel) async throws -> ProductModel {
        try await APIClient.request(target: ProductTarget.uploadProduct(product: product), type: ProductModel.self)
    }
    
    static func likeProduct(id: Int64) async throws {
        _ = try await APIClient.request(target: ProductTarget.like(id: id), type: String.self)
    }
    
    static func cancelLikeProdcut(id: Int64) async throws {
        _ = try await APIClient.request(target: ProductTarget.cancelLike(id: id), type: String.self)
    }
}
