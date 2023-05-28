//
//  ArtistIntroItem.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/16.
//

import SwiftUI
import Kingfisher

struct ArtistIntroItem: View {
    
    let item: ArtistIntroItemModel
    
    init(item: ArtistIntroItemModel) {
        self.item = item
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 40) {
            
            if let imageUrl = item.profile, let url = URL(string: imageUrl) {
                KFImage(url)
                    .placeholder {
                        Image("mock_artist")
                    }
                    .resizable()
                    .frame(width: 80, height: 80)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(40)
            } else {
                Image("mock_artist")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(40)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(item.nickname ?? "")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color.Common.primaryDarkTextColor)
                
                Text(item.introduction ?? "")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color.Common.subtextDarkColor)

            }
            Spacer()
        }
    }
}
