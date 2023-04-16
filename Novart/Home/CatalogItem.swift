//
//  CatalogItem.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/16.
//

import SwiftUI

struct CatalogItem: View {
    var body: some View {
        ZStack {
            Image("mock_home_poster")
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            Image("catalog_dim")
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            HStack {
             
                VStack(alignment: .leading, spacing: 12) {
                    Spacer()
                    
                    Text("졸업 전시")
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
                    
                    Text("서울과학기술대학교\n제40회 디자인학과 산업디자인전공")
                        .font(.system(size: 20, weight: .bold))
                        .lineSpacing(4)
                        .foregroundColor(Color.white)
                    
                    Text("기간ㅣ2023.12.06~2023.12.21\n위치ㅣ서울과학기술대학교 100주년기념관 목산갤러리")
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

struct CatalogItem_Previews: PreviewProvider {
    static var previews: some View {
        CatalogItem()
    }
}
