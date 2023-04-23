//
//  DiscoverView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/09.
//

import SwiftUI

struct DiscoverView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                VStack(alignment: .center, spacing: 0) {
                    CategoryFilterView()
                        .frame(width: geometry.size.width, height: 54)
                    Rectangle()
                        .frame(width: geometry.size.width, height: 1)
                        .foregroundColor(.Common.subtextColor)
                    ProductGridView()
                }
                
                Button {
                    print("add")
                } label: {
                    Image("add_product_button")
                }
                .padding(.bottom, 16)

            }
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
