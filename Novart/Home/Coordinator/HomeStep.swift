//
//  HomeStep.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/06.
//

import UIKit

enum HomeStep: Step {
    case dummy
    
    var target: UIViewController.Type? { nil }
    var animated: Bool { false }
}
