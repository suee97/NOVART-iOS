//
//  ProductUploadStep.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/10.
//

import UIKit

enum ProductUploadStep: Step {
    case detailImage(productEditModel: ProductUploadModel)
    case detailInfo(productEditModel: ProductUploadModel)
    case imageEdit(image: UploadMediaItem)
    case preview(data: ProductPreviewModel, editModel: ProductUploadModel)
    case upload(data: ProductPreviewModel)
    case cancelAlert(isEditScene: Bool)
    case product(id: Int64)
    
    var target: UIViewController.Type? { nil }
    var animated: Bool { false }
}
