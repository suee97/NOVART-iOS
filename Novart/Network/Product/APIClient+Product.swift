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
    
    static func updateProduct(product: ProductUploadRequestModel, productId: Int64) async throws -> ProductModel {
        try await APIClient.request(target: ProductTarget.updateProduct(product: product, id: productId), type: ProductModel.self)
    }
    
    static func likeProduct(id: Int64) async throws -> EmptyResponseModel {
        try await APIClient.request(target: ProductTarget.like(id: id), type: EmptyResponseModel.self)
    }
    
    static func cancelLikeProdcut(id: Int64) async throws -> EmptyResponseModel {
        try await APIClient.request(target: ProductTarget.cancelLike(id: id), type: EmptyResponseModel.self)
    }
    
    static func getRelatedProducts(id: Int64) async throws -> [ProductModel] {
        try await APIClient.request(target: ProductTarget.relatedProducts(productId: id), type: [ProductModel].self)
    }
    
    static func getOtherProdcutFromArtist(productId: Int64, artistId: Int64) async throws -> [ProductModel] {
        try await APIClient.request(target: ProductTarget.otherProductFromArtist(productId: productId, artistId: artistId), type: [ProductModel].self)
    }
    
    static func deleteProduct(id: Int64) async throws -> EmptyResponseModel {
        try await APIClient.request(target: ProductTarget.delete(id: id), type: EmptyResponseModel.self)
    }
}
