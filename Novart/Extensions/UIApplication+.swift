//
//  UIApplication+.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/09.
//

import SwiftUI

extension UIApplication {
    var str: String {
        return "sdfsf"
    }
    
    var keyWindow: UIWindow? {
        return connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
    }
}
