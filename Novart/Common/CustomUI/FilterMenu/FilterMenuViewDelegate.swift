//
//  FilterMenuViewDelegate.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/26.
//

import Foundation

protocol FilterMenuViewDelegate: AnyObject {
    func didTapRowAt(menuView: FilterMenuView, category: CategoryType)
}

protocol FilterMenuViewSendable: AnyObject {
    func didHideMenu()
}
