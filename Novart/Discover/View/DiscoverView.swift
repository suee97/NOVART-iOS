//
//  DiscoverView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/09.
//

import SwiftUI

struct DiscoverView: View {
    
    @ObservedObject var viewModel: DiscoverViewModel
    
    init(viewModel: DiscoverViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                VStack(alignment: .center, spacing: 0) {
                    CategoryFilterView(viewModel: viewModel)
                        .frame(width: geometry.size.width, height: 54)
                    Rectangle()
                        .frame(width: geometry.size.width, height: 1)
                        .foregroundColor(.Common.subtextColor)
                    
                    Spacer()
                        .frame(height: 12)
                    sortView
                    Spacer()
                        .frame(height: 12)
                    
                    ProductGridView(viewModel: viewModel)
                }
                
                Button {
                    print("add")
                } label: {
                    Image("add_product_button")
                }
                .padding(.bottom, 16)

            }
        }
    }
}

extension DiscoverView {
    var sortView: some View {
        HStack(spacing: 4) {
            Button {
                viewModel.isOnlyPurchasable.toggle()
            } label: {
                if viewModel.isOnlyPurchasable {
                    Image("checkmark_fill")
                } else {
                    Image("checkmark_empty")
                }
                
            }
            .buttonStyle(NoHighlightButtonStyle())
            
            Text("구매 가능만 볼래요")
                .foregroundColor(Color.Common.subtextDarkColor)
                .font(.system(size: 14, weight: .regular))
            
            Spacer()
            
            Menu {
                Button("최신순") {
                    viewModel.listOrderType = .new
                }
                Button("인기순") {
                    viewModel.listOrderType = .popular
                }
                Button("낮은 가격") {
                    viewModel.listOrderType = .lowPrice
                }
                Button("높은 가격") {
                    viewModel.listOrderType = .highPrice
                }
            } label: {
                HStack(alignment: .center, spacing: 0) {
                    Text(getListOrderText(type: viewModel.listOrderType))
                        .foregroundColor(Color.Common.gray03)
                        .font(.system(size: 14, weight: .bold))
                        .frame(width: 100, alignment: .trailing)
                    Image("icon_arrow_down")
                }
            }
            .buttonStyle(NoHighlightButtonStyle())
        }
        .padding([.leading, .trailing], 24)
    }
    
    func getListOrderText(type: ListOrderType) -> String {
        switch type {
        case .new:
            return "최신순"
        case .popular:
            return "인기순"
        case .lowPrice:
            return "낮은 가격"
        case .highPrice:
            return "높은 가격"
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView(viewModel: DiscoverViewModel())
    }
}
