//
//  ImageEditorPresentableCoordinator.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/01/13.
//

import UIKit

protocol ImageEditorPresentableCoordinator: AnyObject {
    var imageEditManager: ImageEditManager { get }
    func showImageEditor(using image: UIImage, presenter: UIViewController, completion: @escaping ((UIImage) -> Void))
}

extension ImageEditorPresentableCoordinator {
    func showImageEditor(using image: UIImage, presenter: UIViewController, completion: @escaping ((UIImage) -> Void)) {
        imageEditManager.didFinishCrop = completion
        imageEditManager.presentCropViewController(using: image, presenter: presenter)
    }
}
