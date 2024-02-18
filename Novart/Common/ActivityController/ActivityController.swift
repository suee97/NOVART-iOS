//
//  ActivityController.swift
//  Novart
//
//  Created by Jinwook Huh on 2/18/24.
//

import UIKit

public final class ActivityController {
    let activityViewController: ActivityViewController
    
    public init(activityItems: [Any], applicationActivities: [UIActivity]?, statusBarStyle: UIStatusBarStyle = .default) {
        self.activityViewController = ActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities, statusBarStyle: statusBarStyle)
    }
    
    public var completionWithItemsHandler: UIActivityViewController.CompletionWithItemsHandler? {
        get {
            activityViewController.completionWithItemsHandler
        } set {
            activityViewController.completionWithItemsHandler = newValue
        }
    }
    
    public func show(animated: Bool = true) {
        activityViewController.show(animated: animated)
    }
}

