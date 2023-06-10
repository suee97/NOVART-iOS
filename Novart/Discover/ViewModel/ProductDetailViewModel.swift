//
//  ProductDetailViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/28.
//

import Foundation

final class ProductDetailViewModel: ObservableObject {
    
    @Published var productDetail: ProductDetailModel?
    let productId: String
    let downloadInteractor: ProductDetailDownloadInteractor = ProductDetailDownloadInteractor()
    
    init(productId: String) {
        self.productId = productId
    }
    
    func fetchProductDetail() {
        Task { @MainActor in
            do {
                productDetail = try await downloadInteractor.fetchProdcutDetail(id: productId)
                print("this is product detail")
                print(productDetail?.name)
            } catch {
                
            }
        }
    }
}
