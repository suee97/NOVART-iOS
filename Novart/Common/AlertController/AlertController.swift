//
//  AlertController.swift
//  Novart
//
//  Created by Jinwook Huh on 2/18/24.
//

import UIKit

public protocol AlertControllerDelegate: AnyObject {
    
    func willPresentAlertController(_ alertController: AlertController)
    func didPresentAlertController(_ alertController: AlertController)
    func alertController(_ alertController: AlertController, didDismissWith action: AlertAction?)
    
}

public final class AlertController: NSObject {
    
    private enum StringConstants {
        static let commonVoiceOverValueSelected = "선택됨"
    }
    
    public weak var delegate: AlertControllerDelegate?
    public var allowsEndEditing = true
    
    private(set) var actions: [AlertAction] = []
    private var dismissCompletionBlock: (() -> Void)?
    
    let alertViewController: AlertViewController
    
    public var textFields: [UITextField]? {
        return alertViewController.textFields
    }
    
    public var title: String? {
        get {
            alertViewController.title
        }
        set {
            if newValue == nil, preferredStyle == .alert {
                alertViewController.title = ""
            } else {
                alertViewController.title = newValue
            }
        }
    }
    
    public var message: String? {
        get {
            alertViewController.message
        }
        set {
            alertViewController.message = newValue
        }
    }
    
    public var preferredStyle: UIAlertController.Style {
        return alertViewController.preferredStyle
    }
    
    public var preferredAction: AlertAction? {
        didSet {
            alertViewController.preferredAction = preferredAction?.uiAlertAction
        }
    }
    
    public var actionForAutoDismission: AlertAction? {
        if actions.count == 1 {
            return actions.first
        }
        return firstAction(style: .cancel)
    }
    
    // swiftlint:disable:next function_default_parameter_at_end
    public init(title: String? = nil, message: String?, preferredStyle: UIAlertController.Style) {
        var title = title
        // 스타일이 얼럿에 title 이 nil 인 경우 message 가 bold 처리 되므로 예외처리
        if title == nil, preferredStyle == .alert {
            title = ""
        }
        self.alertViewController = AlertViewController(title: title,
                                                       message: message,
                                                       preferredStyle: preferredStyle)
        
        super.init()
        
        self.title = title
        self.message = message
        self.alertViewController.delegate = self
    }
    
    // swiftlint:disable:next function_default_parameter_at_end
    public init(title: String? = nil, attributedMessage: NSAttributedString?, preferredStyle: UIAlertController.Style) {
        var title = title
        // 스타일이 얼럿에 title 이 nil 인 경우 message 가 bold 처리 되므로 예외처리
        if title == nil, preferredStyle == .alert {
            title = ""
        }
        self.alertViewController = AlertViewController(title: title,
                                                       message: "",
                                                       preferredStyle: preferredStyle)
        
        super.init()
        
        self.title = title
        self.message = ""
        self.alertViewController.delegate = self
        
        if let attributedMessage = attributedMessage {
            self.alertViewController.setValue(attributedMessage, forKey: "attributedMessage")
        }
    }
    
    public func addTextField(configurationHandler: ((UITextField) -> Void)? = nil) {
        alertViewController.addTextField(configurationHandler: configurationHandler)
    }
    
    public func cancelAndDismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.performActionAndDismiss(action: actionForAutoDismission, animated: animated, completion: completion)
    }
    
    public func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.performActionAndDismiss(action: nil, animated: animated, completion: completion)
    }
    
    public func performActionAndDismiss(action: AlertAction? = nil, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.dismissCompletionBlock = completion
        
        if let action = action {
            action.handler?(action)
        }
        
        if (alertViewController.presentingViewController == nil) || alertViewController.isBeingDismissed {
            AlertManager.shared.removeAlertController(self)
            
            delegate?.alertController(self, didDismissWith: action)
            dismissCompletionBlock?()
            dismissCompletionBlock = nil
        } else {
            alertViewController.dismiss(animated: true) { [weak self] in
                guard let sself = self else { return }
                
                AlertManager.shared.removeAlertController(sself)
                sself.delegate?.alertController(sself, didDismissWith: action)
                sself.dismissCompletionBlock?()
                sself.dismissCompletionBlock = nil
            }
        }
        
    }
    
    @discardableResult
    public func show(allowDuplicate: Bool = true,
                     presenter: UIViewController? = nil,
                     file: StaticString = #file,
                     line: UInt = #line) -> AlertController? {
        
        if !Thread.isMainThread {
            assert(false, "")
        }
        
        if !allowDuplicate {
            guard AlertManager.shared.firstAlert(title: title, message: message) == nil else {
                return nil
            }
        }
        
        delegate?.willPresentAlertController(self)
        
        AlertManager.shared.addAlertController(self)
        
        alertViewController.show(true, endEditing: allowsEndEditing, presenter: presenter)
        
        return self
    }
    
    public func addAction(title: String?,
                          style: UIAlertAction.Style = .default,
                          handler: ((_ action: AlertAction) -> Void)? = nil) {
        
        addAction(AlertAction(title: title, style: style, handler: handler))
    }
    
    public func addPreferredAction(_ action: AlertAction) {
        addAction(action)
        preferredAction = action
    }
    
    public func addAction(_ action: AlertAction) {
        actions.append(action)
        
        let uiAlertAction = UIAlertAction(title: action.title, style: action.style) { [weak self] _ in
            guard let sself = self else { return }
            
            action.handler?(action)
            
            sself.delegate?.alertController(sself, didDismissWith: action)
            AlertManager.shared.removeAlertController(sself)
        }
        if let title = action.title, action.checked {
            let accessibilityLabelValue: [String] = [StringConstants.commonVoiceOverValueSelected, title]
            uiAlertAction.accessibilityLabel = accessibilityLabelValue.joined(separator: " ")
        }
        alertViewController.addAction(uiAlertAction)
        
        action.uiAlertAction = uiAlertAction
        
        if let image = action.image {
            uiAlertAction.setValue(image, forKey: "image")
        }
        
        uiAlertAction.isEnabled = action.isEnabled
    }
    
    public func addAction(_ actionClosure: @escaping (() -> AlertAction)) {
        addAction(actionClosure())
    }
    
    public func addConfirmAction(handler: ((AlertAction) -> Void)? = nil) {
        addAction(.confirmActionWithHandler(handler))
    }
    
    public func addCancelAction(handler: ((AlertAction) -> Void)? = nil) {
        addAction(.cancelActionWithHandler(handler))
    }
    
    public func firstAction(style: UIAlertAction.Style) -> AlertAction? {
        return actions.first { $0.style == style }
    }
}

extension AlertController: AlertViewControllerDelegate {
    
    func didPresentAlertViewController(_ alertViewController: AlertViewController) {
        delegate?.didPresentAlertController(self)
    }
}
