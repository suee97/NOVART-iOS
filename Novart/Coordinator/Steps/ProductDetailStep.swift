//
//  ProductDetailStep.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/28.
//

import UIKit

enum ProductDetailStep: Step {
    case comment(productId: Int64)
    case artist(userId: Int64?)
    case product(productId: Int64)
    case exhibition(id: Int64)
    case edit(product: ProductUploadModel)
    case login
    case ask(user: PlainUser)
    case report
    case search(query: String)
    
    var target: UIViewController.Type? { nil }
    var animated: Bool { false }
}
