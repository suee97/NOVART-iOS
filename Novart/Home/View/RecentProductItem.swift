//
//  RecentProductItem.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/16.
//

import SwiftUI
import Kingfisher

struct RecentProductItem: View {
    
    let item: RecentProductItemModel
    
    init(item: RecentProductItemModel) {
        self.item = item
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 4) {
                if let imageUrl = item.thumbnail, let url = URL(string: imageUrl) {
                    KFImage(url)
                        .placeholder {
                            Image("mock_table")
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image("mock_table")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                
                HStack {
                    Text(item.name ?? "")
                        .foregroundColor(Color.Common.primaryDarkTextColor)
                        .font(.system(size: 16, weight: .bold))
                    .padding(.bottom, 2)
                    
                    Spacer()
                    
                    if item.likes {
                        Image("icon_heart_fill")
                    } else {
                        Image("icon_heart")
                    }
                }
                
                Text(item.seller ?? "")
                    .foregroundColor(Color.Common.subtextDarkColor)
                    .font(.system(size: 14, weight: .regular))
            }
        }
    }
}
