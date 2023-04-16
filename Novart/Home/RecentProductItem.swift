//
//  RecentProductItem.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/16.
//

import SwiftUI

struct RecentProductItem: View {
    var body: some View {
        
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 4) {
                Image("mock_table")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                HStack {
                    Text("작품 이름")
                        .foregroundColor(Color.Common.primaryDarkTextColor)
                        .font(.system(size: 16, weight: .bold))
                    .padding(.bottom, 2)
                    
                    Spacer()
                    
                    Image("icon_heart_fill")
                }
                
                Text("작가 이름")
                    .foregroundColor(Color.Common.subtextDarkColor)
                    .font(.system(size: 14, weight: .regular))
            }
        }
    }
}

struct RecentProductItem_Previews: PreviewProvider {
    static var previews: some View {
        RecentProductItem()
    }
}
