//
//  AlertAction.swift
//  Novart
//
//  Created by Jinwook Huh on 2/18/24.
//

import UIKit

public class AlertAction: NSObject, NSCopying {
    
    private enum StringConstants {
        static let commonStringConfirm = "확인"
        static let commonStringCancel = "취소"
    }
    
    public var title: String?
    public var style: UIAlertAction.Style
    public var handler: ((_ action: AlertAction) -> Void)?
    
    public weak var uiAlertAction: UIAlertAction?
    
    public var isEnabled = true {
        didSet {
            uiAlertAction?.isEnabled = isEnabled
        }
    }
    
    public var image: UIImage? {
        didSet {
            uiAlertAction?.setValue(image, forKey: "image")
        }
    }
    
    public var checked: Bool = false {
        didSet {
            uiAlertAction?.setValue(checked, forKey: "checked")
        }
    }
    
    public init(style: UIAlertAction.Style) {
        self.style = style
    }
    
    public convenience init(title: String?,
                            style: UIAlertAction.Style,
                            handler: ((AlertAction) -> Void)? = nil) {
        self.init(style: style)
        self.title = title
        self.handler = handler
    }
    
    deinit {
        
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let newAction = AlertAction(style: style)
        newAction.title = title
        newAction.isEnabled = isEnabled
        newAction.handler = handler
        return newAction
    }
    
    public static func action(title: String?,
                              style: UIAlertAction.Style,
                              handler: ((AlertAction) -> Void)?) -> AlertAction {
        return AlertAction(title: title,
                           style: style,
                           handler: handler)
    }
    
    public static func confirmAction(_ title: String? = nil,
                                     _ handler: ((AlertAction) -> Void)? = nil) -> AlertAction {
        return AlertAction(title: title ?? StringConstants.commonStringConfirm,
                           style: .default,
                           handler: handler)
    }
    
    public static func cancelAction(_ title: String? = nil,
                                    _ handler: ((AlertAction) -> Void)? = nil) -> AlertAction {
        return AlertAction(title: title ?? StringConstants.commonStringCancel,
                           style: .cancel,
                           handler: handler)
    }
    
    public static func confirmActionWithHandler(_ handler: ((AlertAction) -> Void)?) -> AlertAction {
        return AlertAction(title: StringConstants.commonStringConfirm,
                           style: .default,
                           handler: handler)
    }
    
    public static func cancelActionWithHandler(_ handler: ((AlertAction) -> Void)?) -> AlertAction {
        return AlertAction(title: StringConstants.commonStringCancel,
                           style: .cancel,
                           handler: handler)
    }
    
}
