//
//  ProductDetailInteractor.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/22.
//

import Foundation

final class ProductDetailInteractor {
    func fetchProductDetail(id: Int64) async throws -> ProductDetailModel {
        try await APIClient.getProductDetail(id: id)
    }
    
    func fetchRelatedProducts(id: Int64) async throws -> [ProductModel] {
        try await APIClient.getRelatedProducts(id: id)
    }
    
    func fetchOtherProductsFromArtist(productId: Int64, artistId: Int64) async throws -> [ProductModel] {
        try await APIClient.getOtherProdcutFromArtist(productId: productId, artistId: artistId)
    }
    
    func fetchExhibitions(artistId: Int64) async throws -> [ExhibitionModel] {
        try await APIClient.fetchArtistsExhibition(id: artistId)
    }
}
