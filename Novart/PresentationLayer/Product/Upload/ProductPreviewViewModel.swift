//
//  ProductPreviewViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/31.
//

import UIKit
import Combine

final class ProductPreviewViewModel {
    private weak var coordinator: ProductUploadCoordinator?
    let productPreviewData: ProductPreviewModel
    
    init(productPreviewData: ProductPreviewModel, coordinator: ProductUploadCoordinator?) {
        self.coordinator = coordinator
        self.productPreviewData = productPreviewData
    }
    
    @MainActor
    func startUploadScene() {
        coordinator?.navigate(to: .upload(data: productPreviewData))
    }
}
