//
//  BottomSheetable.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/02/11.
//

import UIKit

protocol BottomSheetable: UIViewController {
    
    var bottomSheetNavigationController: BottomSheetNavigationController? { get }
    
}

extension BottomSheetable {
    
    var bottomSheetNavigationController: BottomSheetNavigationController? {
        navigationController as? BottomSheetNavigationController
    }
    
}
