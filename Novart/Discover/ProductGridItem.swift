//
//  ProductGridItem.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/23.
//

import SwiftUI

struct ProductGridItem: View {
    var body: some View {
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
            
            Text("100,000원")
                .foregroundColor(Color.Common.subtextDarkColor)
                .font(.system(size: 14, weight: .regular))
            
            HStack(alignment: .center) {
                Text("방태림 작가")
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

struct ProductGridItem_Previews: PreviewProvider {
    static var previews: some View {
        ProductGridItem()
    }
}
