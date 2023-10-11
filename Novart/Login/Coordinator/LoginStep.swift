//
//  LoginStep.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/06.
//

import UIKit

enum LoginStep: Step {
    case main
    case policy
    
    var target: UIViewController.Type? { nil }
    var animated: Bool { false }
}
