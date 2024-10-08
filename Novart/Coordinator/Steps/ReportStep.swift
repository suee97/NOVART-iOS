//
//  ReportStep.swift
//  Novart
//
//  Created by Jinwook Huh on 2/12/24.
//

import UIKit

enum ReportStep: Step {
    case reportDone
    
    var target: UIViewController.Type? { nil }
    var animated: Bool { false }
}

