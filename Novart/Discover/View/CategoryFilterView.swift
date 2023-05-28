//
//  CategoryFilterView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/23.
//

import SwiftUI

struct CategoryFilterView: View {
    
    let categories = ["전체", "그림", "가구", "조명", "공예"]
    
    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            Button {
                print("조회수")
            } label: {
                HStack(alignment: .center, spacing: 0) {
                    Text("조회수")
                        .foregroundColor(Color.Common.primaryDarkTextColor)
                        .font(.system(size: 16, weight: .bold))
                    Image("icon_drop_down")
                }
            }
            categoryStackView


        }
        .padding([.leading, .trailing], 24)
    }
    
    var categoryStackView: some View {
        HStack(alignment: .center, spacing: 4) {
            ForEach(categories, id: \.self) { category in
                
                Button {
                    print(category)
                } label: {
                    Text(category)
                        .foregroundColor(Color.Common.subtextDarkColor)
                        .font(.system(size: 14, weight: .regular))
                        .padding([.leading, .trailing], 14)
                        .padding([.top, .bottom], 8)
                        .background(Color.Common.primaryTextColor)
                        .foregroundColor(Color.white)
                        .cornerRadius(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.Common.subtextColor, lineWidth: 1)
                        )
                }
                .buttonStyle(NoHighlightButtonStyle())
            }
        }
    }
}



struct CategoryFilterView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryFilterView()
    }
}
