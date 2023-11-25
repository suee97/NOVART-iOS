//
//  MainStep.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/25.
//

import UIKit

enum MainStep: Step {
    case home
    case discovery
    case myPage
    
    var target: UIViewController.Type? { nil }
    var animated: Bool { false }
}
