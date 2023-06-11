//
//  ProductDetailViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/28.
//

import Foundation

final class ProductDetailViewModel: ObservableObject {
    
    @Published var productDetail: ProductDetailModel?
    @Published var like: Bool = false
    
    let productId: String
    let downloadInteractor: ProductDetailDownloadInteractor = ProductDetailDownloadInteractor()
    
    private var hasPostedLike: Bool = false
    
    init(productId: String) {
        self.productId = productId
    }
    
    func fetchProductDetail() {
        Task { @MainActor in
            do {
                productDetail = try await downloadInteractor.fetchProdcutDetail(id: productId)
                like = productDetail?.likes ?? false
            } catch {
            }
        }
    }
    
    func postLike() {
        Task {
            hasPostedLike = true
            _ = try await downloadInteractor.postLike(id: productId)
            like.toggle()
        }
    }
}
