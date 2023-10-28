//
//  ProductDetailStep.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/28.
//

import UIKit

enum ProductDetailStep: Step {
    case comment
    case artist
    case product
    case exhibition
    
    var target: UIViewController.Type? { nil }
    var animated: Bool { false }
}
