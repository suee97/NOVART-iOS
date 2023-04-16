//
//  NoHighlightButton.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/15.
//

import SwiftUI

struct NoHighlightButton<Label: View>: View {
    let action: () -> Void
    let label: () -> Label

    init(action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Label) {
        self.action = action
        self.label = label
    }

    var body: some View {
        Button(action: action) {
            label()
        }
        .buttonStyle(NoHighlightButtonStyle())
    }
}
