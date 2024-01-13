//
//  ProductUploadStep.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/10.
//

import UIKit

enum ProductUploadStep: Step {
    case detailImage(coverImages: [UploadMediaItem])
    case detailInfo(coverImages: [UploadMediaItem], detailImage: [UploadMediaItem])
    case imageEdit
    case preview(data: ProductPreviewModel)
    case upload(data: ProductPreviewModel)
    
    var target: UIViewController.Type? { nil }
    var animated: Bool { false }
}
