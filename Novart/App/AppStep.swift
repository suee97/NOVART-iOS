//
//  AppStep.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/25.
//

import UIKit

enum AppStep: Step {
    case login
    case main
    
    var target: UIViewController.Type? { nil }
    var animated: Bool { false }
}
