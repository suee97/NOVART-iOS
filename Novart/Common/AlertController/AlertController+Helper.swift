//
//  AlertController+Helper.swift
//  Novart
//
//  Created by Jinwook Huh on 2/18/24.
//

import UIKit

public extension AlertController {
    
    static func alertController(title: String?, message: String?, preferredStyle: UIAlertController.Style) -> AlertController {
        return AlertController(title: title,
                               message: message,
                               preferredStyle: preferredStyle)
    }
    
    static func dismissAll(cancelAction: Bool = true, animated: Bool = true, completion: (() -> Void)? = nil) {
        AlertManager.shared.dismissAll(cancelAction: cancelAction, animated: animated, completion: completion)
    }
    
    static func hideAllAlertWindow(_ hidden: Bool = true) {
        AlertManager.shared.hideAllAlertWindow(hidden)
    }
    
    static var isPresentedAlert: Bool {
        return nil != AlertManager.shared.alertControllers.first {
            $0.alertViewController.isViewLoaded && ($0.alertViewController.view.window?.windowScene != nil)
        }
    }
    
    static var presentedMessage: String? {
        if let alert = AlertManager.shared.alertControllers.first {
            return alert.message
        }
        return nil
    }
    
    static func checkDuplicatedAlert(title: String?, message: String?) -> Bool {
        if let alert = AlertManager.shared.alertControllers.first {
            if alert.title == title, alert.message == message {
                return true
            }
        }
        return false
    }
    
    // swiftlint:disable:next function_default_parameter_at_end
    static func confirmAlert(title: String? = nil,
                             message: String?,
                             confirmTitle: String? = nil,
                             handler: ((_ action: AlertAction) -> Void)? = nil) -> AlertController {
        let alert = AlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.confirmAction(confirmTitle, handler))
        return alert
    }
    
    // swiftlint:disable:next function_default_parameter_at_end
    static func cancelConfirmAlert(title: String? = nil,
                                   message: String?,
                                   cancelTitle: String? = nil,
                                   confirmTitle: String? = nil,
                                   cancelHandler: ((_ action: AlertAction) -> Void)? = nil,
                                   confirmHandler: ((_ action: AlertAction) -> Void)? = nil) -> AlertController {
        let alert = AlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.cancelAction(cancelTitle, cancelHandler))
        alert.addAction(.confirmAction(confirmTitle, confirmHandler))
        return alert
    }
    
    // swiftlint:disable:next function_default_parameter_at_end
    static func textFieldAlert(title: String? = nil,
                               message: String?,
                               textFieldDefaultText: String? = nil,
                               textFieldPlaceholder: String? = nil,
                               cancelTitle: String? = nil,
                               confirmTitle: String? = nil,
                               cancelHandler: ((_ action: AlertAction) -> Void)? = nil,
                               confirmHandler: ((_ action: AlertAction, _ text: String?) -> Void)? = nil) -> AlertController {
        let alert = AlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = textFieldDefaultText
            textField.placeholder = textFieldPlaceholder
            textField.isSecureTextEntry = false
        }
        alert.addAction(.cancelAction(cancelTitle, cancelHandler))
        alert.addAction(.confirmAction(confirmTitle) { action in
            confirmHandler?(action, alert.textFields?.first?.text)
        })
        return alert
    }
    
}
