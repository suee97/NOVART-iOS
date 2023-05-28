//
//  ArtistIntroView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/16.
//

import SwiftUI

struct ArtistIntroView: View {
    
    let items: [ArtistIntroItemModel]
    
    init(items: [ArtistIntroItemModel]) {
        self.items = items
    }
    
    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(items, id: \.id) { item in
                VStack(spacing: 0) {
                    ArtistIntroItem(item: item)
                    Spacer()
                        .frame(height: 24)
                    Rectangle()
                        .foregroundColor(Color.Common.subtextColor)
                        .frame(height: 1)
                    Spacer()
                        .frame(height: 24)
                }
            }
        }
        .padding([.leading, .trailing], 24)
    }
}

struct ArtistIntroView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistIntroView(items: [])
    }
}
