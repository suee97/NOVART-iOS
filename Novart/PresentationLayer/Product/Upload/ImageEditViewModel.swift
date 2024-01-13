//
//  ImageEditViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/01/01.
//

import Foundation

final class ImageEditViewModel {
    
    private weak var coordinator: ProductUploadCoordinator?
    
    init(coordinator: ProductUploadCoordinator?) {
        self.coordinator = coordinator
    }
}
