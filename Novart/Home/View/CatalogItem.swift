//
//  CatalogItem.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/16.
//

import SwiftUI
import Kingfisher

struct CatalogItem: View {
    
    let item: CatalogItemModel
    
    init(item: CatalogItemModel) {
        self.item = item
    }
    
    var body: some View {
        ZStack {
            if let imageUrl = item.imageUrl, let url = URL(string: imageUrl) {
                KFImage(url)
                    .placeholder {
                        Image("mock_home_poster")
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image("mock_home_poster")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            
            Image("catalog_dim")
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            HStack {
             
                VStack(alignment: .leading, spacing: 12) {
                    Spacer()
                    
                    Text(tagName(type: item.category))
                        .font(.system(size: 12, weight: .regular))
                        .padding([.leading, .trailing], 8)
                        .padding([.top, .bottom], 4)
                        .background(Color.Common.primaryTintColor.opacity(0.6))
                        .foregroundColor(Color.white)
                        .cornerRadius(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color(hex: "999999"), lineWidth: 1)
                        )
                    
                    Text(item.name ?? "")
                        .font(.system(size: 20, weight: .bold))
                        .lineSpacing(4)
                        .foregroundColor(Color.white)
                    
                    Text("기간ㅣ\(item.duration ?? "미정")\n위치ㅣ\(item.location ?? "미정")")
                        .font(.system(size: 12, weight: .regular))
                        .lineSpacing(4)
                        .foregroundColor(Color.Common.subtextColor)
                    
                    Spacer()
                        .frame(height: 44)
                    
                }
                
                Spacer()
                
            }
            .padding(.leading, 24)
            
        }

    }
}

extension CatalogItem {
    private func tagName(type: CatalogCategory) -> String {
        switch type {
        case .art:
            return "작품"
        case .artist:
            return "작가"
        case .graduation:
            return "졸업 전시"
        }
    }
}
