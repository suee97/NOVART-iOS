//
//  SectionHeaderView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/15.
//

import SwiftUI

struct SectionHeaderView: View {
    
    private var title: String
    private var isLogoEnabled: Bool
    
    init(title: String, isLogoEnabled: Bool) {
        self.title = title
        self.isLogoEnabled = isLogoEnabled
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                
                if isLogoEnabled {
                    Text("NOVART ")
                        .foregroundColor(Color.Common.primaryTintColor)
                }
                Text(title)
                Spacer()
                
                Button {
                    print("인기 예술풀")
                } label: {
                    Image("icon_chevron_right")
                }
                .buttonStyle(NoHighlightButtonStyle())
            }
            .font(.system(size: 16, weight: .bold))
        }
        .padding(.leading, 24)
        .padding(.trailing, 24)
    }
}

struct SectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeaderView(title: "인기 예술품", isLogoEnabled: true)
    }
}
