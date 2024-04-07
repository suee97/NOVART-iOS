//
//  ExhibitionDetailStep.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/04.
//

import UIKit

enum ExhibitionDetailStep: Step {
    case comment(exhibitionId: Int64)
    case artist(userId: Int64?)
    case exhibition
    case login
    case ask(user: PlainUser)
    
    var target: UIViewController.Type? { nil }
    var animated: Bool { false }
}
