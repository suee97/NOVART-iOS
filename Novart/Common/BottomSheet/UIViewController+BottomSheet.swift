//
//  UIViewController+BottomSheet.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/02/11.
//

import UIKit

public extension UIViewController {
    
    @MainActor
    func presentSheet(_ viewControllerToPresent: UIViewController, with configuration: BottomSheetConfiguration) {
        guard let sheet = viewControllerToPresent.sheetPresentationController else { return }
        
        viewControllerToPresent.isModalInPresentation = configuration.isModalInPresentation
        sheet.setConfiguration(configuration)
        present(viewControllerToPresent, animated: true)
    }
    
}

