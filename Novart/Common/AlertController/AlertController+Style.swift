//
//  AlertController+Style.swift
//  Novart
//
//  Created by Jinwook Huh on 2/18/24.
//

import UIKit

public extension AlertController {
    
    func setBackgroundColor(color: UIColor) {
        if let bgView = alertViewController.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = color
        }
    }
    
    func setTitle(font: UIFont?, color: UIColor?) {
        guard let title = self.title else {
            return
        }
        
        let attributeString = NSMutableAttributedString(string: title)// 1
        if let titleFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font: titleFont], // 2
                                          range: NSRange(location: 0, length: title.utf8.count))
        }
        
        if let titleColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor: titleColor], // 3
                                          range: NSRange(location: 0, length: title.utf8.count))
        }
        alertViewController.setValue(attributeString, forKey: "attributedTitle")// 4
    }
    
    func setMessage(font: UIFont?, color: UIColor?) {
        guard let message = self.message else {
            return
        }
        
        let attributeString = NSMutableAttributedString(string: message)
        if let messageFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font: messageFont],
                                          range: NSRange(location: 0, length: message.utf8.count))
        }
        
        if let messageColorColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor: messageColorColor],
                                          range: NSRange(location: 0, length: message.utf8.count))
        }
        alertViewController.setValue(attributeString, forKey: "attributedMessage")
    }
    
    func setTint(color: UIColor) {
        alertViewController.view.tintColor = color
    }
    
}
