//
//  ProductTarget.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/22.
//

import Foundation
import Alamofire

enum ProductTarget: TargetType {
    case productDetail(id: Int64)
    case uploadProduct(product: ProductUploadRequestModel)
    case updateProduct(product: ProductUploadRequestModel, id: Int64)
    case like(id: Int64)
    case cancelLike(id: Int64)
    case otherProductFromArtist(productId: Int64, artistId: Int64)
    case relatedProducts(productId: Int64)
    case delete(id: Int64)
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        switch self {
        case let .productDetail(id):
            return "arts/\(id)"
        case .uploadProduct:
            return "arts"
        case let .updateProduct(_, id):
            return "arts/\(id)"
        case let .like(id):
            return "likes/\(id)"
        case let .cancelLike(id):
            return "likes/\(id)"
        case let .otherProductFromArtist(productId, artistId):
            return "arts/\(productId)/artist/\(artistId)/others"
        case let .relatedProducts(productId):
            return "arts/\(productId)/recommends"
        case let .delete(id):
            return "arts/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .productDetail:
            return .get
        case .uploadProduct:
            return .post
        case .updateProduct:
            return .put
        case .like:
            return .post
        case .cancelLike:
            return .delete
        case .otherProductFromArtist:
            return .get
        case .relatedProducts:
            return .get
        case .delete:
            return .delete
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .productDetail:
            return .query(nil)
        case let .uploadProduct(product):
            return .body(product)
        case let .updateProduct(product, _):
            return .body(product)
        case .like:
            return .body(nil)
        case .cancelLike:
            return .body(nil)
        case .otherProductFromArtist:
            return .query(nil)
        case .relatedProducts:
            return .query(nil)
        case .delete:
            return .query(nil)
        }
    }
}
