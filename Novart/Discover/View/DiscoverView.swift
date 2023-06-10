//
//  DiscoverView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/09.
//

import SwiftUI

struct DiscoverView: View {
    
    @ObservedObject var viewModel = DiscoverViewModel()
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                VStack(alignment: .center, spacing: 0) {
                    CategoryFilterView()
                        .frame(width: geometry.size.width, height: 54)
                    Rectangle()
                        .frame(width: geometry.size.width, height: 1)
                        .foregroundColor(.Common.subtextColor)
                    ProductGridView(items: viewModel.products)
                }
                
                Button {
                    print("add")
                } label: {
                    Image("add_product_button")
                }
                .padding(.bottom, 16)

            }
        }
        .onAppear {
            viewModel.fetchProducts()
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
