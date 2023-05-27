//
//  PopularProductView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/15.
//

import SwiftUI

struct PopularProductView: View {
    
    let data = (1...10).map { "Item \($0)" }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 14) {
                   Spacer()
                    .frame(width: 10, height: 260)
                ForEach(data, id: \.self) { _ in
                    PopularProductItem()
                        .frame(width: 260, height: 260)
                        .cornerRadius(8)
                }
            }
        }
    }
}

struct PopularProductView_Previews: PreviewProvider {
    static var previews: some View {
        PopularProductView()
    }
}
