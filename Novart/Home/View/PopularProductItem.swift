//
//  PopularProductItem.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/16.
//

import SwiftUI
import Kingfisher

struct PopularProductItem: View {
    
    let item: PopularProductItemModel
    
    init(item: PopularProductItemModel) {
        self.item = item
    }
    
    var body: some View {
        ZStack {
            
            if let imageUrl = item.thumbnailImageUrl, let url = URL(string: imageUrl) {
                KFImage(url)
                    .placeholder {
                        Image("mock_chair")
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(8)
                
            } else {
                Image("mock_chair")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(8)
            }
            
            Image("popular_dim")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .cornerRadius(8)
            
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(tagName(type: item.category))
                        .font(.system(size: 10, weight: .regular))
                        .padding([.leading, .trailing], 8)
                        .padding([.top, .bottom], 4)
                        .background(Color(hex: "1C1C1C").opacity(0.4))
                        .foregroundColor(Color.white)
                        .cornerRadius(4)

                    Spacer()
                    
                    Text(item.name ?? "")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color.Common.primaryTextColor)
                    HStack {
                        Text(item.seller ?? "")
                            .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color.Common.primaryTextColor)
                        Spacer()
                        Image("icon_white_cheveron_right")

                    }
                }
                .padding(.top, 16)
                .padding(.bottom, 18)
                
                Spacer()
            }
            .padding(.leading, 24)
            .padding(.trailing, 18)
        }
        .frame(width: 260, height: 260)

    }
}

extension PopularProductItem {
    private func tagName(type: NovartItemCategory) -> String {
        switch type {
        case .painting:
            return "그림"
        case .furniture:
            return "가구"
        case .light:
            return "조명"
        case .craft:
            return "공예"
        default:
            return ""
        }
    }
}
