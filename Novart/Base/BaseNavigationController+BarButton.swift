//
//  BaseNavigationController+BarButton.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/25.
//

import UIKit

extension UINavigationController {
    
    func backButtonItem(tintColor: UIColor? = nil) -> UIBarButtonItem {
        let popAction = UIAction { [weak self] _ in
            guard let self else {
                return
            }
            self.popViewController(animated: true)
        }
        return makeButtonItem(title: nil, image: UIImage(), tintColor: tintColor, primaryAction: popAction, menus: nil)
    }

}

extension UINavigationController {
    
    private func makeButtonItem(title: String?, image: UIImage?, tintColor: UIColor?, primaryAction: UIAction?, menus: UIMenu?) -> UIBarButtonItem {
        var buttonImage = image
        if let tintColor = tintColor {
            buttonImage = buttonImage?.withTintColor(tintColor)
        }
        return UIBarButtonItem(title: title, image: buttonImage, primaryAction: primaryAction, menu: menus)
    }
    
}

