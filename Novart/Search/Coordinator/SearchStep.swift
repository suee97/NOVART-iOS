//
//  SearchStep.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/06.
//

import UIKit

enum SearchStep: Step {
    case search(SearchResultModel)
    case product
    case artist
    
    var target: UIViewController.Type? { nil }
    var animated: Bool { false }
}

