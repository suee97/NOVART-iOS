//
//  HomeStep.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/06.
//

import UIKit

enum HomeStep: Step {
    case productDetail(id: Int64)
    case nickiname
    
    var target: UIViewController.Type? { nil }
    var animated: Bool { false }
}
