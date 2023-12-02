//
//  ExhibitionDetailStep.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/04.
//

import UIKit

enum ExhibitionDetailStep: Step {
    case comment
    case artist
    case exhibition
    
    var target: UIViewController.Type? { nil }
    var animated: Bool { false }
}
