//
//  ProductGridItem.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/23.
//

import SwiftUI
import Kingfisher

struct ProductGridItem: View {
    
    let item: PopularProductItemModel
    
    init(item: PopularProductItemModel) {
        self.item = item
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            if let imageUrl = item.thumbnailImageUrl, let url = URL(string: imageUrl) {
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
            
            Text("\(item.price)원")
                .foregroundColor(Color.Common.subtextDarkColor)
                .font(.system(size: 14, weight: .regular))
            
            HStack(alignment: .center) {
                Text("\(item.seller ?? "") 작가")
                    .foregroundColor(Color.Common.primaryTintColor)
                    .font(.system(size: 12, weight: .bold))
                    .padding([.leading, .trailing], 8)
                    .padding([.top, .bottom], 4)
                    .background(Color.Common.subTintColor)
                    .cornerRadius(4)
                
                Spacer()
                
                Text("거래완료")
                    .foregroundColor(Color.Common.primaryTextColor)
                    .font(.system(size: 12, weight: .bold))
                    .padding([.leading, .trailing], 8)
                    .padding([.top, .bottom], 4)
                    .background(Color.Common.primaryDarkTextColor)
                    .cornerRadius(4)
            }
        }
    }
}
