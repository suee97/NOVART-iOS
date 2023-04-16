//
//  PopularProductItem.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/16.
//

import SwiftUI

struct PopularProductItem: View {
    var body: some View {
        ZStack {
            Image("mock_chair")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .cornerRadius(8)
            
            Image("popular_dim")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .cornerRadius(8)
            
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("가구")
                        .font(.system(size: 10, weight: .regular))
                        .padding([.leading, .trailing], 8)
                        .padding([.top, .bottom], 4)
                        .background(Color(hex: "1C1C1C").opacity(0.4))
                        .foregroundColor(Color.white)
                        .cornerRadius(4)

                    Spacer()
                    
                    Text("작품 이름")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color.Common.primaryTextColor)
                    HStack {
                        Text("작가 이름")
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

struct PopularProductItem_Previews: PreviewProvider {
    static var previews: some View {
        PopularProductItem()
    }
}
