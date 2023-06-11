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
        static let subTintColor = Color("sub_tint_color")
        static let subtextColor = Color("subtext_color")
        static let primaryTextColor = Color("primary_text_color")
        static let primaryDarkTextColor = Color("primary_dark_text_color")
        static let subtextDarkColor = Color("subtext_dark_color")
        static let gray00 = Color("gray_00")
        static let gray01 = Color("gray_01")
        static let gray02 = Color("gray_02")
        static let gray03 = Color("gray_03")
        static let white = Color("white")
        static let sub = Color("sub")
        static let wireDarkGray = Color("wire_darkgray")
        static let yellow = Color("yellow")
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
