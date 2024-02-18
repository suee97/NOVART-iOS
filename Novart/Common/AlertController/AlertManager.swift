//
//  AlertManager.swift
//  Novart
//
//  Created by Jinwook Huh on 2/18/24.
//

import UIKit

public final class AlertManager: NSObject {
    
    public static var shared = AlertManager()
    
    public var alertControllers: Set<AlertController> = []
    
    override init() {
        
    }
    
    public func addAlertController(_ alertController: AlertController) {
        alertControllers.insert(alertController)
    }
    
    public func removeAlertController(_ alertController: AlertController) {
        alertControllers.remove(alertController)
    }
    
    public func dismissAll(cancelAction: Bool = true, animated: Bool = true, completion: (() -> Void)?) {
        var completionCalled = false
        alertControllers.forEach {
            $0.performActionAndDismiss(action: cancelAction ? $0.actionForAutoDismission : nil) { [weak self] in
                if self?.alertControllers.isEmpty == true, !completionCalled {
                    completionCalled = true
                    completion?()
                }
            }
        }
    }
    
    public func hideAllAlertWindow(_ hidden: Bool) {
        alertControllers.forEach {
            $0.alertViewController.hideAlertWindow(hidden)
        }
    }
    
    // swiftlint:disable:next function_default_parameter_at_end
    public func firstAlert(title: String? = nil, message: String?) -> AlertController? {
        return alertControllers.first { $0.title == title && $0.message == message }
    }
    
    // swiftlint:disable:next function_default_parameter_at_end
    public func alert(title: String? = nil, message: String?) -> [AlertController] {
        return alertControllers.filter { $0.title == title && $0.message == message }
    }
    
}
