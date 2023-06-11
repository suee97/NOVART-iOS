//
//  CategoryFilterView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/23.
//

import SwiftUI

struct CategoryFilterView: View {
    
    @ObservedObject private var viewModel: DiscoverViewModel
    
    let categories: [NovartItemCategory] = [.all, .painting, .furniture, .light, .craft]
    
    init(viewModel: DiscoverViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 6) {
//            Button {
//                print("조회수")
//            } label: {
//                HStack(alignment: .center, spacing: 0) {
//                    Text("조회수")
//                        .foregroundColor(Color.Common.primaryDarkTextColor)
//                        .font(.system(size: 16, weight: .bold))
//                    Image("icon_drop_down")
//                }
//            }
            categoryStackView
            Spacer()


        }
        .padding([.leading, .trailing], 24)
    }
    
    var categoryStackView: some View {
        HStack(alignment: .center, spacing: 4) {
            ForEach(categories, id: \.self) { category in

                Button {
                    viewModel.selectedCategory = category
                } label: {
                    if viewModel.selectedCategory == category {
                        Text(catetoryName(for: category))
                            .foregroundColor(Color.Common.white)
                            .font(.system(size: 14, weight: .regular))
                            .padding([.leading, .trailing], 14)
                            .padding([.top, .bottom], 8)
                            .background(Color.Common.primaryTintColor)
                            .foregroundColor(Color.white)
                            .cornerRadius(4)

                    } else {
                        Text(catetoryName(for: category))
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
                }
                .buttonStyle(NoHighlightButtonStyle())
            }
        }
    }
}


private extension CategoryFilterView {
    func catetoryName(for category: NovartItemCategory) -> String {
        switch category {
        case .all:
            return "전체"
        case .painting:
            return "그림"
        case .furniture:
            return "가구"
        case .light:
            return "조명"
        case .craft:
            return "공예"
        }
    }
}

struct CategoryFilterView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryFilterView(viewModel: DiscoverViewModel())
    }
}
