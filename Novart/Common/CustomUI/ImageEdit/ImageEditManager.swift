//
//  ImageEditManager.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/01/13.
//

import UIKit
import CropViewController

class ImageEditManager: NSObject {
    
    var didFinishCrop: ((UIImage) -> Void)?
    
    func presentCropViewController(using image: UIImage, presenter: UIViewController) {
        let viewController = CropViewController(image: image)
        viewController.aspectRatioPreset = .presetSquare
        viewController.toolbarPosition = .bottom
        viewController.doneButtonTitle = "완료"
        viewController.cancelButtonTitle = "취소"
        viewController.delegate = self
        presenter.present(viewController, animated: true)
    }
}

extension ImageEditManager: CropViewControllerDelegate {
    
       func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
           cropViewController.dismiss(animated: true)
       }
       
       func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
           cropViewController.dismiss(animated: true)
           didFinishCrop?(image)
       }
    
}
