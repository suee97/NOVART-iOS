//
//  Color+.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/08.
//

import SwiftUI

extension Color {
    enum Common {
        static let primaryTintColor = Color("primary_tint_color")
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
      }
}
