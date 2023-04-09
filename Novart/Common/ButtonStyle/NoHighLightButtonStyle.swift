//
//  NoHighLightButtonStyle.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/08.
//

import SwiftUI

struct NoHighlightButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .compositingGroup()
            .opacity(configuration.isPressed ? 1.0 : 1.0)
    }
}
