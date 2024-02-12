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
    case productUpload
    case LoginModal
    case Close
    
    case product(Int64)
    case artist(Int64)
    case exhibitionDetail(id: Int64)
    case block
    case report
    case ask
    
    var target: UIViewController.Type? { nil }
    var animated: Bool { false }
}

