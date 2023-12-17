//
//  MyPageStep.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/06.
//

import UIKit

enum MyPageStep: Step {
    case MyPageMain
    case MyPageProfileEdit
    case MyPageSetting
    case MyPageNotification
    
    var target: UIViewController.Type? { nil }
    var animated: Bool { false }
}

