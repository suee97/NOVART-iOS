//
//  Step.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/25.
//

import UIKit

protocol Step {
    var target: UIViewController.Type? { get }
    var animated: Bool { get }
}
