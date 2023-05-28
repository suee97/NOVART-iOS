//
//  RecentProductView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/16.
//

import SwiftUI

struct RecentProductView: View {
    
    var items: [RecentProductItemModel]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    init(items: [RecentProductItemModel]) {
        self.items = items
    }
    
    var body: some View {
        GeometryReader { geometry in
            LazyVGrid(columns: columns, spacing: 40) {
                ForEach(items, id: \.id) { item in
                    RecentProductItem(item: item)
                        .frame(width: (geometry.size.width - 62) / 2, height: (geometry.size.width - 62) / 2 + 48)

                }
            }
            .padding([.leading, .trailing], 24)
            
        }
    }
}

struct RecentProductView_Previews: PreviewProvider {
    static var previews: some View {
        RecentProductView(items: [])
    }
}
