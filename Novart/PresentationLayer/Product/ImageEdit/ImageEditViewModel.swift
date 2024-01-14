//
//  ImageEditViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/01/01.
//

import UIKit

final class ImageEditViewModel {
    
    private weak var coordinator: ProductUploadCoordinator?
    var image: UIImage
    
    init(image: UIImage, coordinator: ProductUploadCoordinator?) {
        self.image = image
        self.coordinator = coordinator
    }
}
