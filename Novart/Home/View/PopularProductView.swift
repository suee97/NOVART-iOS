//
//  PopularProductView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/15.
//

import SwiftUI

struct PopularProductView: View {
    
    @State private var isShowingProductDetail: Bool = false
    var items: [PopularProductItemModel]
    
    init(items: [PopularProductItemModel]) {
        self.items = items
    }
        
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 14) {
                   Spacer()
                    .frame(width: 10, height: 260)
                ForEach(items, id: \.id) { item in
                    
                    NavigationLink(destination: ProductDetailView(viewModel: ProductDetailViewModel(productId: item.id), isShowing: $isShowingProductDetail), isActive: $isShowingProductDetail) {
                        PopularProductItem(item: item)
                            .frame(width: 260, height: 260)
                            .cornerRadius(8)
                    }
                    
//                    NavigationLink(destination: ProductDetailView(viewModel: ProductDetailViewModel(productId: item.id), isShowing: $isShowingProductDetail)) {
//                        PopularProductItem(item: item)
//                            .frame(width: 260, height: 260)
//                            .cornerRadius(8)
//                    }
                }
            }
        }
    }
}

struct PopularProductView_Previews: PreviewProvider {
    static var previews: some View {
        PopularProductView(items: [])
    }
}
