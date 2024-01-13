//
//  ProductUploadInteractor.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/01/07.
//

import Foundation

final class ProductUploadInteractor {
    func getPresignedUrl(filename: String) async throws -> PresignedUrlModel {
        try await APIClient.getPresignedUrl(filename: filename, category: .product)
    }
    
    func getPresignedUrls(filenames: [String]) async throws -> [PresignedUrlModel] {
        let categories: [MediaTarget.Category] = [MediaTarget.Category](repeating: .product, count: filenames.count)
        return try await APIClient.getPresignedUrls(filenames: filenames, categories: categories)
    }
    
    @discardableResult
    func uploadToS3(presignedUrls: [String], images: [Data]) async throws -> [Data?] {
        var result: [Data?] = []
        
        try await withThrowingTaskGroup(of: Data?.self) { group in
            for (idx, url) in presignedUrls.enumerated() {
                group.addTask {
                    try await APIClient.uploadJpegData(uploadUrl: url, data: images[idx])
                }
                
                for try await data in group {
                    result.append(data)
                }
            }
        }
        
        return result
    }
    
    func uploadProductToServer(product: ProductUploadRequestModel) async throws -> ProductModel {
        return try await APIClient.uploadProduct(product: product)
    }
}
