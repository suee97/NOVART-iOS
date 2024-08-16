//
//  ImageCompresser.swift
//  Plain
//
//  Created by Jinwook Huh on 8/16/24.
//

import UIKit

struct ImageCompresser {
    
    func compressImage(_ image: UIImage, compressiontQuality: CGFloat) -> Data? {
        return image.jpegData(compressionQuality: compressiontQuality)
    }
    
    func compressImage(_ image: UIImage, toSizeInMegaBytes compressedSize: Double) -> Data? {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return nil }
        let roughSize = Double(imageData.count) / (1024 * 1024)
        
        let quality = compressedSize * 2 / roughSize
        
        if roughSize < compressedSize || quality > 1.0 {
            return imageData
        }
        
        return compressImage(image, compressiontQuality: quality)
    }
}
 
