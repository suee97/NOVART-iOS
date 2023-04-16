//
//  RecentProductView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/16.
//

import SwiftUI

struct RecentProductView: View {
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        GeometryReader { geometry in
            LazyVGrid(columns: columns, spacing: 40) {
                ForEach(0..<4) { _ in
                    RecentProductItem()
                        .frame(width: (geometry.size.width - 62) / 2, height: (geometry.size.width - 62) / 2 + 48)

                }
            }
            .padding([.leading, .trailing], 24)
            
        }
    }
}

struct RecentProductView_Previews: PreviewProvider {
    static var previews: some View {
        RecentProductView()
    }
}
