//
//  NicknameTextField.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/01.
//

import UIKit

class NicknameTextField: UITextField {

    var textInset: CGFloat = 14

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: textInset, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: textInset, dy: 0)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: textInset, dy: 0)
    }
}
