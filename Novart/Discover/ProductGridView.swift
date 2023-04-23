//
//  ProductGridView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/23.
//

import SwiftUI

struct ProductGridView: View {
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                availabilityCheckView
                    .padding([.top], 8)
                    .padding([.bottom], 12)
                    .padding([.leading], 24)
                
                LazyVGrid(columns: columns, spacing: 40) {
                    ForEach(0..<8) { _ in
                        ProductGridItem()
                            .frame(width: (geometry.size.width - 62) / 2, height: (geometry.size.width - 62) / 2 + 73)

                    }
                }
                .padding([.leading, .trailing], 24)
                
                Spacer()
                    .frame(height: 40)
            }
        }
    }
    
    var availabilityCheckView: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 4) {
                Button {
                    print("구매가능")
                } label: {
                    Image("checkmark_fill")
                }
                .buttonStyle(NoHighlightButtonStyle())

                Text("구매가능만 있어요")
                    .foregroundColor(Color.Common.subtextDarkColor)
                    .font(.system(size: 14, weight: .regular))
                
                Spacer()
            }
        }
    }
}

struct ProductGridView_Previews: PreviewProvider {
    static var previews: some View {
        ProductGridView()
    }
}
